terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
IAM
======*/


/*==== instance profiles =======*/

resource "aws_iam_instance_profile" "default" {
  name  = "${var.db_access_type}-default_instance_profile"
  role = "${aws_iam_role.default.name}"
}

resource "aws_iam_instance_profile" "cault" {
  name  = "cault_instance_profile"
  role = "${aws_iam_role.cault.name}"
}

resource "aws_iam_role" "cault" {
  name = "consul-vault"

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

/*==== default role ===========*/

resource "aws_iam_role" "default" {
  name = "default"
  path = "/"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "autoscaling.amazonaws.com",
          "codedeploy.amazonaws.com"
        ]
      }
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

# TODO: understand how to differentiate roles
resource "aws_iam_role" "datomic_peer" {
  name = "datomic_peer"
  path = "/"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "autoscaling.amazonaws.com",
          "codedeploy.amazonaws.com"
        ]
      }
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

/*==== policy attachments =====*/

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  count      = "${length(var.iam_policy_arns)}"
  policy_arn = "${element(var.iam_policy_arns, count.index)}"
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  role       = "${aws_iam_role.ecs_service.name}"
  policy_arn = "${aws_iam_policy.ecs_service.arn}"
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = "${aws_iam_role.ecs_execution.name}"
  policy_arn = "${aws_iam_policy.ecs_execution.arn}"
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = "${aws_iam_role.ecs_task.name}"
  policy_arn = "${aws_iam_policy.ecs_task.arn}"
}

resource "aws_iam_role_policy_attachment" "ecs_autoscaling" {
  role       = "${aws_iam_role.ecs_autoscaling.name}"
  policy_arn = "${aws_iam_policy.ecs_autoscaling.arn}"
}

resource "aws_iam_role_policy_attachment" "datomic_peer" {
  role       = "${aws_iam_role.datomic_peer.name}"
  policy_arn = "${aws_iam_policy.dynamo_read.arn}"
}

resource "aws_iam_role_policy_attachment" "cault_s3" {
  role       = "${aws_iam_role.cault.name}"
  policy_arn = "${aws_iam_policy.s3_full_access.arn}"
}


##------------------ ECS (APPLICATIONS) -------------------##

/*==== service-linked roles ===*/

resource "aws_iam_role" "ecs_service" {
  name = "ecs_service"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_execution" {
  name = "ecs_execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_task" {
  name = "ecs_task"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_autoscaling" {
  name = "ecs_autoscaling"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


##------------------ IAM (DEVELOPERS) ---------------------##

resource "aws_iam_role" "iam_dev" {
  name = "iam_developer"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "iam.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
