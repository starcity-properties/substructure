data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.ecr_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.iam_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}
