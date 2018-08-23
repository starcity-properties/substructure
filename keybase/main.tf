terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
IAM
======*/

/*==== alias =================*/

resource "aws_iam_account_alias" "alias" {
  account_alias = "starcity-master"
}


/*==== account management ====*/

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 20
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}


/*==== access keys + ssh =====*/
