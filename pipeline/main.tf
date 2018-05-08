# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

# s3 bucket

resource "aws_s3_bucket" "pipeline" {
  bucket = "${var.s3_bucket_name}-pipeline"
  region = "${var.aws_region}"

  versioning {
    enabled = true
  }
}
