data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "${var.tfstate_bucket}"
    key    = "${var.iam_global_remote_state_key}"
    region = "${var.tfstate_region}"
  }
}
