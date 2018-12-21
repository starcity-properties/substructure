terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_dynamodb_table" "datomic_kvs" {
  name           = "${var.ddb_datomic_kv_table}"
  read_capacity  = "${var.ddb_read_capacity}"
  write_capacity = "${var.ddb_write_capacity}"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  lifecycle {
    prevent_destroy = false
  }
}