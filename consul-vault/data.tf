data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}

data "terraform_remote_state" "route53" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.route53_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}
