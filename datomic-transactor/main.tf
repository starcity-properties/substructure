terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*==== Datomic transactor (x1) ======*/

data "aws_ami" "datomic_transactor" {
  most_recent = true

  filter {
    name   = "name"
    values = ["datomic-0.9.5544-star-development"]
  }
}


# s3 bucket for the transactor logs
resource "aws_s3_bucket" "transactor_logs" {
  bucket        = "${var.transactor_name}-datomic-logs"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}


# transactor launch config
resource "aws_launch_configuration" "datomic_transactor" {
  name_prefix          = "dtx-"

  image_id             = "${data.aws_ami.datomic_transactor.image_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.datomic_transactor.name}"
  key_name             = "${var.ssh_key_name}"

  user_data = "${data.template_file.transactor_user_data.rendered}"

  security_groups = [
    "${data.terraform_remote_state.vpc.datomic_inbound_id}",
    "${data.terraform_remote_state.vpc.http_outbound_id}"
  ]

  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

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
    peer_role       = "${data.terraform_remote_state.iam.datomic_peer_role}"

    s3_log_bucket        = "${aws_s3_bucket.transactor_logs.id}"
    cloudwatch_dimension = "${var.cloudwatch_dimension}"
    dynamodb_table       = "${var.dynamodb_table}"
    db_name              = "${var.db_name}"

    partition   = "${var.partition}"
    protocol    = "${var.protocol}"
    port        = "${var.port}"
    license_key = "${var.license_key}"
  }
}


# autoscaling group for launching transactors
resource "aws_autoscaling_group" "datomic_asg" {
  name = "${var.transactor_name}-dtx"

  availability_zones   = "${var.availability_zones}"
  max_size             = "${var.instance_count}"
  min_size             = "${var.instance_count}"
  launch_configuration = "${aws_launch_configuration.datomic_transactor.name}"

  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

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
