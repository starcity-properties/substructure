terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.iam_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}

data "terraform_remote_state" "dynamodb" {
  backend = "s3"
  config {
    region = "${var.tfstate_region}"
    bucket = "${var.tfstate_bucket}"
    key = "${var.dynamodb_remote_state_key}"
  }
}

# =============================================================
# Datomic AMI
# =============================================================

data "aws_ami" "datomic_transactor_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["starcity/images/datomic-pro-0.9.5544-*"]
  }
}

# =============================================================
# EC2 instance role
# =============================================================

data "aws_iam_policy_document" "datomic_transactor" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "datomic_transactor" {
  name = "datomic_transactor"
  assume_role_policy = "${data.aws_iam_policy_document.datomic_transactor.json}"
}

# Read only access to the DynamoDB table
data "aws_iam_policy_document" "ddb_datomic_kv_read_only_access" {
  version = "2012-10-17"
  statement {
    sid = "DynamoTableRead"
    effect = "Allow"
    actions = ["dynamodb:GetItem", "dynamodb:BatchGetItem", "dynamodb:Scan", "dynamodb:Query"]
    resources = ["arn:aws:dynamodb:*:${var.aws_account_ids["staging"]}:table/${var.ddb_datomic_kv_table}"]
  }
}

data "aws_iam_policy_document" "ddb_datomic_kv_full_access" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = ["dynamodb:*"]
    resources = ["arn:aws:dynamodb:*:${var.aws_account_ids["staging"]}:table/${var.ddb_datomic_kv_table}"]
  }
}

resource "aws_iam_role_policy" "ddb_kv_full_access" {
  name = "datomic-transactor"
  role = "${aws_iam_role.datomic_transactor.id}"
  policy = "${data.aws_iam_policy_document.ddb_datomic_kv_full_access.json}"
}


# Write access to the S3 bucket with Datomic logs.
data "aws_iam_policy_document" "s3_datomic_logs_write_access" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources =
    ["arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}",
      "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}/*"]
  }
}

resource "aws_iam_role_policy" "transactor_logs" {
  name = "s3_logs_access"
  role = "${aws_iam_role.datomic_transactor.id}"
  policy = "${data.aws_iam_policy_document.s3_datomic_logs_write_access.json}"
}

# =============================================================
# S3 Datomic logs
# =============================================================

resource "aws_s3_bucket" "transactor_logs" {
  bucket        = "${var.transactor_name}-datomic-logs"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}




data "template_file" "transactor_user_data" {
  template = "${file("${path.module}/scripts/run-transactor.sh")}"

  vars {
    xmx                    = "${var.transactor_xmx}"
    xms                    = "${var.transactor_xms}"
    java_opts              = "${var.java_opts}"
    memory_index_max       = "${var.transactor_memory_index_max}"
    memory_index_threshold = "${var.transactor_memory_index_threshold}"
    object_cache_max       = "${var.transactor_object_cache_max}"

    region          = "${var.aws_region}"
    transactor_role = "${aws_iam_role.datomic_transactor.name}"
//    peer_role       = "${data.terraform_remote_state.iam.datomic_peer_role}"

    s3_log_bucket        = "${aws_s3_bucket.transactor_logs.id}"
    cloudwatch_dimension = "${var.cloudwatch_dimension}"
    dynamodb_table       = "${var.ddb_datomic_kv_table}"
    db_name              = "${var.datomic_db_name}"

    partition   = "${var.datomic_partition}"
    protocol    = "${var.datomic_protocol}"
    port        = "${var.datomic_port}"
    license_key = "${var.datomic_license_key}"
  }
}


resource "aws_iam_instance_profile" "datomic_transactor" {
  name = "starcity-datomic-transactor"
  role = "${aws_iam_role.datomic_transactor.name}"
}

resource "aws_launch_configuration" "datomic_transactor" {
//  name_prefix          = "dtx-"

//  image_id = "ami-f51264c5"
  image_id             = "${data.aws_ami.datomic_transactor_ami.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.datomic_inbound.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.datomic_transactor.name}"
  key_name             = "${aws_key_pair.datomic-transactor.key_name}"

  user_data = "${data.template_file.transactor_user_data.rendered}"

//  associate_public_ip_address = true
//  security_groups = [
//    "${data.terraform_remote_state.vpc.datomic_inbound_id}",
//    "${data.terraform_remote_state.vpc.http_outbound_id}"
//  ]

  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "datomic-transactor" {
  key_name_prefix = "datomic-transactor-key"
  public_key = "${var.datomic_ssh_public_key}"
}


resource "aws_autoscaling_group" "datomic_asg" {
  name = "${var.transactor_name}-dtx"

  availability_zones   = "${var.availability_zones}"
  launch_configuration = "${aws_launch_configuration.datomic_transactor.name}"

  max_size             = "${var.instance_count}"
  min_size             = "${var.instance_count}"
//  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "datomic-transactor-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Type"
    value               = "Datomic"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "datomic_inbound" {
  name        = "datomic_datomic_inbound"
  description = "Allow access to Datomic Transactor"

//  vpc_id  = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

//  ingress {
//    from_port   = 4334
//    to_port     = 4334
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "datomic_transactors"
  }
  lifecycle {
    create_before_destroy = true
  }
}