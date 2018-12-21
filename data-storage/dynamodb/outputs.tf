
output "ddb_datomic_kvs_name" {
  value = "${aws_dynamodb_table.datomic_kvs.name}"
}

output "ddb_datomic_kvs_arn" {
  value ="${aws_dynamodb_table.datomic_kvs.arn}"
}