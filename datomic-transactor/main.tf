terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}

# transactor role. ec2 instances can assume the role of a transactor
resource "aws_iam_role" "transactor" {
  name = "${var.transactor_name}-transactor"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

# policy with write access to cloudwatch
resource "aws_iam_role_policy" "transactor_cloudwatch" {
  name = "cloudwatch_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:PutMetricDataBatch"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      },
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# s3 bucket for the transactor logs
resource "aws_s3_bucket" "transactor_logs" {
  bucket        = "${var.transactor_name}-datomic-logs"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}

# policy with write access to the transactor logs
resource "aws_iam_role_policy" "transactor_logs" {
  name = "s3_logs_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}",
        "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}/*"
      ]
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

# policy with complete access to the dynamodb table
resource "aws_iam_role_policy" "transactor" {
  name  = "dynamo_access"
  role  = "${aws_iam_role.transactor.id}"
  count = "${var.protocol == "ddb" ? 1 : 0}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table}"
    }
  ]
}
EOF
}

# instance profile which assumes the transactor role
resource "aws_iam_instance_profile" "transactor" {
  name = "${var.transactor_name}-datomic-transactor"
  role = "${aws_iam_role.transactor.name}"
}

# transactor launch config
resource "aws_launch_configuration" "transactor" {
  name_prefix          = "${var.transactor_name}-datomic-transactor-"
  image_id             = "${var.ami}"
  instance_type        = "${var.transactor_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.transactor.name}"

  # TODO:
  security_groups = ["${data.terraform_remote_state.vpc.internal_inbound_id}"]
  user_data       = "${data.template_file.transactor_user_data.rendered}"
  key_name        = "${var.key_name}"

  #  associate_public_ip_address = true

  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "transactor_user_data" {
  template = "${file("${path.module}/files/run-transactor.sh")}"

  vars {
    xmx                    = "${var.transactor_xmx}"
    java_opts              = "${var.transactor_java_opts}"
    region                 = "${var.aws_region}"
    transactor_role        = "${aws_iam_role.transactor.name}"
    memory_index_max       = "${var.transactor_memory_index_max}"
    s3_log_bucket          = "${aws_s3_bucket.transactor_logs.id}"
    memory_index_threshold = "${var.transactor_memory_index_threshold}"
    object_cache_max       = "${var.transactor_object_cache_max}"
    license_key            = "${var.datomic_license}"
    cloudwatch_dimension   = "${var.cloudwatch_dimension}"

    protocol            = "${var.protocol}"
    aws_dynamodb_table  = "${var.dynamodb_table}"
    aws_dynamodb_region = "${var.aws_region}"
  }
}

# autoscaling group for launching transactors
resource "aws_autoscaling_group" "datomic_asg" {
  availability_zones   = "${var.availability_zones}"
  name                 = "${var.transactor_name}_transactors"
  max_size             = "${var.instance_count}"
  min_size             = "${var.instance_count}"
  launch_configuration = "${aws_launch_configuration.transactor.name}"

  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.private_subnets}"]

  tag {
    key                 = "Name"
    value               = "${var.transactor_name}-transactor"
    propagate_at_launch = true
  }

  tag {
    key                 = "Type"
    value               = "Datomic"
    propagate_at_launch = true
  }
}

resource "aws_dynamodb_table" "datomic" {
  name           = "${var.dynamodb_table}"
  read_capacity  = "${var.dynamo_read_capacity}"
  write_capacity = "${var.dynamo_write_capacity}"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  lifecycle {
    # prevent_destroy = true
  }
}
