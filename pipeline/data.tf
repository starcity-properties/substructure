data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}



data "terraform_remote_state" "ecs" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.ecs_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}
