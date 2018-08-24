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
resource "aws_iam_user" "app" {
  count = "${length(var.applications)}"
  name = "${element(var.applications, count.index)}"
  path = "/"
}

/*==== devs =======*/

# imported
resource "aws_iam_user" "dev" {
  count = "${length(var.developers)}"
  name = "${element(var.developers, count.index)}"
  path = "/"

  force_destroy = true
}

/*==== membership =*/

/* DEVS */
resource "aws_iam_group_membership" "developers" {
  name = "engineering-team"

  users = [
    "${aws_iam_user.dev.*.name}"
  ]

  group = "${aws_iam_group.developer.name}"
}

/* APPS */
resource "aws_iam_group_membership" "applications" {
  name = "application-services"

  users = [
    "${aws_iam_user.app.*.name}"
  ]

  group = "${aws_iam_group.application.name}"
}

/* ADMINS */
resource "aws_iam_user_group_membership" "administrator" {
  count = "${length(var.administrators)}"
  user = "${element(var.administrators, count.index)}"

  groups = [
    "${aws_iam_group.dev_administrator.name}",
    "${aws_iam_group.stage_administrator.name}",
    "${aws_iam_group.prod_administrator.name}"
  ]
}

/*==== policy attachments =====*/

resource "aws_iam_policy_attachment" "dev_admin" {
  name       = "dev_admin_group_policy"
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

resource "aws_iam_policy_attachment" "developers_iam" {
  name       = "developers_iam_policy"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.password_update.arn}"
}

resource "aws_iam_policy_attachment" "developers_view_only" {
  name       = "developers_view_only_policy"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.view_only_full_access.arn}"
}

/*==== roles ======*/
