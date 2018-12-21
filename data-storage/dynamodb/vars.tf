# =============================================================
# AWS provider variables (inherited)
# =============================================================

variable "aws_region" {
  description = "aws region"
}

# =============================================================
# Dynamo DB variables (inherited)
# =============================================================

variable "ddb_datomic_kv_table" {
  description = "DynamoDB table for Datomic key values."
}

variable "ddb_read_capacity" {
  description = "DynamoDB read capacity."
}

variable "ddb_write_capacity" {
  description = "DyanmoDB write capacity."
}