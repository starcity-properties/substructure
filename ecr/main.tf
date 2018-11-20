terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
ECR repository
======*/

resource "aws_ecr_repository" "image" {
  name = "${var.repository_name}"
}


/*====
Docker
======*/
