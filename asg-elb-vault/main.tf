# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

# launch configuration
resource "aws_launch_configuration" "vault_service" {
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.instance.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.vault_service.name}"

  # DEBUG
  key_name = "${var.key_name}"
  user_data = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size = 20
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"
}

# instance role & profile

resource "aws_iam_instance_profile" "vault_service" {
  name = "${var.service_name}-vault-service"
  role = "${aws_iam_role.vault_service.name}"
}

resource "aws_iam_role" "vault_service" {
  name = "${var.service_name}-vault-service"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "autoscaling.amazonaws.com"
        ]
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy" "s3_all_access" {
  name = "s3_all_access"
  role = "${aws_iam_role.vault_service.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# auto-scaling group
resource "aws_autoscaling_group" "vault_service" {
  name                      = "${var.service_name}-${aws_launch_configuration.vault_service.name}"
  launch_configuration      = "${aws_launch_configuration.vault_service.id}"
  availability_zones        = ["${data.aws_availability_zones.all.names}"]
  vpc_zone_identifier       = ["${data.terraform_remote_state.vpc.public_subnets}"]
  load_balancers            = ["${aws_elb.vault_service.name}"]
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  min_elb_capacity          = "${var.min_size}"
  wait_for_capacity_timeout = "0"

  health_check_type = "ELB"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.service_name}"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name   = "${var.service_name}-instance"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

# DEBUG ----------------------------------------------------

resource "aws_security_group_rule" "allow_ssh_inbound_instance" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# -------------------------------------------------------------

resource "aws_security_group_rule" "allow_http_outbound_instance" {
  type              = "egress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_instance" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = "${var.server_port}"
  to_port     = "${var.server_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_availability_zones" "all" {}


# elb
resource "aws_elb" "vault_service" {
  name            = "${var.service_name}-elb"
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 6
    timeout             = 3
    interval            = 120
    target              = "HTTP:${var.server_port}/"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# allow to talk to outside world, since default is not
resource "aws_security_group" "elb" {
  name   = "${var.service_name}-elb"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.elb.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.elb.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
