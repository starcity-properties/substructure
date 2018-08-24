terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*==== IAM + keybase.io ======*/


/*==== alias =================*/

resource "aws_iam_account_alias" "alias" {
  account_alias = "starcity-master"
}

/*==== account management ====*/

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

/*==== access keys + ssh =====*/

locals {
<<<<<<< HEAD
  count = "${length(keys(var.keybase_identities))}"
  user_names = ["${data.terraform_remote_state.iam.developer_iam_user_names}"]
  access_keys = ["${data.terraform_remote_state.iam.developer_access_keys}"]
=======
  user_names = ["${data.terraform_remote_state.iam.developer_iam_user_names}"]
  access_keys = ["${data.terraform_remote_state.iam.developer_access_keys}"]
  count = "${length("${data.terraform_remote_state.iam.developer_iam_user_names}")}"
>>>>>>> create keybase module for secrets and passwords; update iam-global module accordingly
}

resource "aws_iam_user_login_profile" "developer" {
  count = "${local.count}"
<<<<<<< HEAD
  user = "${lookup(var.keybase_identities[count.index], "dev")}"
  pgp_key = "keybase:${lookup(var.keybase_identities[count.index], "kb")}"
=======
  user = "${element(local.user_names, count.index)}"
  pgp_key = "keybase:${var.keybase_identities[element(local.user_names, count.index)]}"
>>>>>>> create keybase module for secrets and passwords; update iam-global module accordingly

  password_reset_required = true
}

resource "aws_iam_access_key" "developer" {
  count = "${local.count}"
<<<<<<< HEAD
  user = "${lookup(var.keybase_identities[count.index], "dev")}"
  pgp_key = "keybase:${lookup(var.keybase_identities[count.index], "kb")}"
=======
  user = "${element(local.user_names, count.index)}"
  pgp_key = "keybase:${var.keybase_identities[element(local.user_names, count.index)]}"
>>>>>>> create keybase module for secrets and passwords; update iam-global module accordingly
}
