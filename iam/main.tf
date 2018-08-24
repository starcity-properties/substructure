terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


<<<<<<< HEAD
/*==== IAM ======*/
=======
# CALCULATED

# description = "the aws account id for respective environment: development, staging, or production"
locals  {
  aws_account_id = "${lookup(var.aws_account_ids, var.environment, 'Not here!')}"
}


/*====
IAM
======*/
>>>>>>> add calculated aws_account_id based on environment


/*==== instance profiles =======*/

# TODO what is the purpose of the instance profile?
resource "aws_iam_instance_profile" "cault" {
  name  = "cault_instance_profile"
  role = "${aws_iam_role.cault.name}"
}


/*==== policy attachments =====*/

# resource "aws_iam_role_policy_attachment" "default" {
#   role       = "${aws_iam_role.default.name}"
#   count      = "${length(var.iam_policy_arns)}"
#   policy_arn = "${element(var.iam_policy_arns, count.index)}"
# }

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
