# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

# launch configuration

resource "aws_launch_configuration" "web_service" {
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.instance.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.web_service.name}"

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

resource "aws_iam_instance_profile" "web_service" {
  name = "${var.service_name}-web-service"
  role = "${aws_iam_role.web_service.name}"
}

resource "aws_iam_role" "web_service" {
  name = "${var.service_name}-web-service"

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
  role = "${aws_iam_role.web_service.id}"

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

resource "aws_autoscaling_group" "web_service" {
  name                      = "${var.service_name}-${aws_launch_configuration.web_service.name}"
  launch_configuration      = "${aws_launch_configuration.web_service.id}"
  availability_zones        = ["${data.aws_availability_zones.all.names}"]
  load_balancers            = ["${aws_elb.web_service.name}"]
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  min_elb_capacity          = "${var.min_size}"
  vpc_zone_identifier       = ["${data.terraform_remote_state.vpc.public_subnets}"]
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

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "${var.tfstate_region}"
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

resource "aws_elb" "web_service" {
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

# codedeploy app
# https://github.com/skyscrapers/terraform-codedeploy/blob/master/app/codedeploy.tf

data "aws_caller_identity" "current" {}

resource "aws_codedeploy_app" "codedeploy_app" {
  name = "${var.service_name}-codedeploy-app"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = "${aws_codedeploy_app.codedeploy_app.name}"
  deployment_group_name = "${var.service_name}"
  service_role_arn      = "${data.terraform_remote_state.codedeploy.role_arn}"
  autoscaling_groups    = ["${aws_autoscaling_group.web_service.name}"]

  load_balancer_info {
    elb_info {
      name = "${aws_elb.web_service.name}"
    }
  }

  # deployment_style {
  #   deployment_option = "WITH_TRAFFIC_CONTROL"
  #   deployment_type   = "BLUE_GREEN"
  # }

  auto_rollback_configuration {
    enabled = "${var.rollback_enabled}"
    events  = "${var.rollback_events}"
  }
}

resource "aws_iam_policy" "deployer_policy" {
  name        = "${var.service_name}-deployer-policy"
  description = "Policy to create a codedeploy application revision and to deploy it, for application ${aws_codedeploy_app.codedeploy_app.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect" : "Allow",
      "Action" : [
        "codedeploy:CreateDeployment"
      ],
      "Resource" : [
        "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deploymentgroup:${aws_codedeploy_app.codedeploy_app.name}/*"
      ]
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource" : [
        "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deploymentconfig:*"
      ]
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "codedeploy:GetApplicationRevision"
      ],
      "Resource" : [
        "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:application:${aws_codedeploy_app.codedeploy_app.name}"
      ]
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "codedeploy:RegisterApplicationRevision"
      ],
      "Resource" : [
        "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:application:${aws_codedeploy_app.codedeploy_app.name}"
      ]
    }
    ${element(formatlist(", { \"Effect\" : \"Allow\", \"Action\" : [ \"s3:PutObject*\", \"s3:ListBucket\" ], \"Resource\" : [ \"%s/*\", \"%s\" ] }, { \"Effect\" : \"Allow\", \"Action\" : [ \"s3:ListAllMyBuckets\" ], \"Resource\" : [ \"*\" ] }", compact(list(data.terraform_remote_state.codedeploy.bucket_arn)), compact(list(data.terraform_remote_state.codedeploy.bucket_arn))), 0)}
  ]
}
EOF
}

data "terraform_remote_state" "codedeploy" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.codedeploy_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}
