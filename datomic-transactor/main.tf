/*====
Datomic transactor (x1)
======*/


# s3 bucket for the transactor logs
resource "aws_s3_bucket" "transactor_logs" {
  bucket        = "${var.transactor_name}-datomic-logs"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}


# instance profile which assumes the transactor role
resource "aws_iam_instance_profile" "transactor" {
  name = "${var.transactor_name}-dtx-transactor"
  role = "${aws_iam_role.transactor.name}"
}


# transactor launch config
resource "aws_launch_configuration" "datomic_transactor" {
  name_prefix          = "dtx-"

  image_id             = "${var.ami}"
  instance_type        = "${var.transactor_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.datomic_transactor.name}"

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
    transactor_role        = "${aws_iam_role.datomic_transactor.name}"
    memory_index_max       = "${var.transactor_memory_index_max}"
    s3_log_bucket          = "${aws_s3_bucket.transactor_logs.id}"
    memory_index_threshold = "${var.transactor_memory_index_threshold}"
    object_cache_max       = "${var.transactor_object_cache_max}"
    license_key            = "${var.datomic_license}"
    cloudwatch_dimension   = "${var.cloudwatch_dimension}"
    partition              = "${var.partition}"
    protocol               = "${var.protocol}"
    aws_dynamodb_table     = "${var.dynamodb_table}"
    aws_dynamodb_region    = "${var.aws_region}"
  }
}


# autoscaling group for launching transactors
resource "aws_autoscaling_group" "datomic_asg" {
  availability_zones   = "${var.availability_zones}"
  name                 = "${var.transactor_name}_transactors"
  max_size             = "${var.instance_count}"
  min_size             = "${var.instance_count}"
  launch_configuration = "${aws_launch_configuration.datomic_transactor.name}"

  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.private_subnets}"]

  tag {
    key                 = "Name"
    value               = "datomic-transactor"
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
