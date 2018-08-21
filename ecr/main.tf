terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
ECR repository
======*/

resource "aws_ecr_repository" "docker_image" {
  name = "${var.repository_name}"
}

data "aws_ecr_repository" "docker_image" {
  name = "${var.repository_name}"
}
