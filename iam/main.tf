terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
IAM
======*/

/*==== groups =====*/

resource "aws_iam_group" "dev_administrator" {
  name = "development_administrator"
  path = "/"
}

resource "aws_iam_group" "stage_administrator" {
  name = "staging_administrator"
  path = "/"
}

resource "aws_iam_group" "prod_administrator" {
  name = "production_administrator"
  path = "/"
}

resource "aws_iam_group" "developer" {
  name = "developer"
  path = "/"
}

resource "aws_iam_group" "application" {
  name = "application"
  path = "/"
}

/*==== apps =======*/

# imported
resource "aws_iam_user" "starcity_web" {
  name = "starcity-web"
  path = "/"
}

resource "aws_iam_user" "odin" {
  name = "odin"
  path = "/"
}

resource "aws_iam_user" "teller" {
  name = "teller"
  path = "/"
}

/*==== devs =======*/

# imported
resource "aws_iam_user" "venator" {
  # josh
  name = "venator"
  path = "/"
}

# imported
resource "aws_iam_user" "therese" {
  # therese
  name = "therese"
  path = "/"
}

resource "aws_iam_user" "asmodeus" {
  # andres
  name = "asmodeus"
  path = "/"
}

resource "aws_iam_user" "queenie" {
  # queenie
  name = "queenie"
  path = "/"
}

resource "aws_iam_user" "allen" {
  # allen
  name = "allen"
  path = "/"
}

resource "aws_iam_user" "diana" {
  # diana
  name = "diana"
  path = "/"
}


/*==== membership =*/

/* DEVS */
resource "aws_iam_group_membership" "developers" {
  name = "starcity-engineering-team"

  users = [
    "${aws_iam_user.venator.name}",
    "${aws_iam_user.therese.name}",
    "${aws_iam_user.asmodeus.name}",
    "${aws_iam_user.queenie.name}",
    "${aws_iam_user.allen.name}",
    "${aws_iam_user.diana.name}"
  ]

  group = "${aws_iam_group.developer.name}"
}

/* APPS */
resource "aws_iam_group_membership" "applications" {
  name = "starcity-applications"

  users = [
    "${aws_iam_user.starcity_web.name}",
    "${aws_iam_user.odin.name}",
    "${aws_iam_user.teller.name}"
  ]

  group = "${aws_iam_group.application.name}"
}

/* ADMINS */
resource "aws_iam_user_group_membership" "therese_administrator" {
  user = "${aws_iam_user.therese.name}"

  groups = [
    "${aws_iam_group.dev_administrator.name}",
    "${aws_iam_group.stage_administrator.name}",
    "${aws_iam_group.prod_administrator.name}"
  ]
}

resource "aws_iam_user_group_membership" "venator_administrator" {
  user = "${aws_iam_user.venator.name}"

  groups = [
    "${aws_iam_group.dev_administrator.name}",
    "${aws_iam_group.stage_administrator.name}",
    "${aws_iam_group.prod_administrator.name}"
  ]
}


/*==== policies ===*/

resource "aws_iam_policy" "dev_admin" {
  name        = "development_administrator_policy"
  path        = "/"
  description = "Allows assuming the development administration role on the development account."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::384840006489:role/administrator"
    }
}
EOF
}

resource "aws_iam_policy" "stage_admin" {
  name        = "staging_administrator_policy"
  path        = "/"
  description = "Allows assuming the staging administration role on the staging account."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::713989059586:role/administrator"
    }
}
EOF
}

resource "aws_iam_policy" "prod_admin" {
  name        = "production_administrator_policy"
  path        = "/"
  description = "Allows assuming the production administration role on the production account."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::081344606926:role/administrator"
    }
}
EOF
}


/*==== policy attachments =====*/

# SAMPLE:
# resource "aws_iam_policy_attachment" "sample" {
#   name       = "sample_name"
#   users      = ["${aws_iam_user.user.name}"]
#   roles      = ["${aws_iam_role.role.name}"]
#   groups     = ["${aws_iam_group.group.name}"]
#   policy_arn = "${aws_iam_policy.policy.arn}"
# }

resource "aws_iam_policy_attachment" "dev_admin" {
  name       = "dev_admin_group_policy"
  # users      = ["${aws_iam_user.user.name}"]
  # roles      = ["${aws_iam_role.role.name}"]
  groups     = ["${aws_iam_group.dev_administrator.name}"]
  policy_arn = "${aws_iam_policy.dev_admin.arn}"
}

resource "aws_iam_policy_attachment" "stage_admin" {
  name       = "stage_admin_group_policy"
  groups     = ["${aws_iam_group.stage_administrator.name}"]
  policy_arn = "${aws_iam_policy.stage_admin.arn}"
}

resource "aws_iam_policy_attachment" "prod_admin" {
  name       = "prod_admin_group_policy"
  groups     = ["${aws_iam_group.prod_administrator.name}"]
  policy_arn = "${aws_iam_policy.prod_admin.arn}"
}


/*==== roles ======*/
