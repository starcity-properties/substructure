# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

# data "terraform_remote_state" "vpc" {
#   backend = "s3"

#   config {
#     bucket = "${var.tfstate_bucket}"
#     key    = "${var.vpc_remote_state_key}"
#     region = "${var.tfstate_region}"
#   }
# }

module "jenkins" {
  source = "../modules/jenkins"

  vpc_id        = "${data.aws_vpc.default.id}"
  subnet_id     = "${element(data.aws_subnet_ids.default.ids, 0)}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
}

data "aws_vpc" "default" {
  default = "${var.vpc_id == "" ? true : false}"
  id      = "${var.vpc_id}"
}

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}
