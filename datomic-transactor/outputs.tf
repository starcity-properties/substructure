output "dynamodb_table_name" {
  value = "${aws_dynamodb_table.datomic.name}"
}

output "datomic_uri" {
  value = "datomic:${var.protocol}://${var.aws_region}/${var.dynamodb_table}/${var.db_name}"
}
