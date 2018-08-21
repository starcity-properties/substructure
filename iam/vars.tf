# INHERITED

variable "aws_region" {
  description = "aws region"
}


# REQUIRED ENVIRONMENT-SPECIFIC

variable "aws_account_id" {
  description = "the aws account id for respective environment: development, staging, or production"
}

variable "iam_policy_arns" {
  description = "list of policies to be attached to a role"
  type = "list"
  default = []
}

variable "db_access_type" {
  description = "one of `app` (backend service) or `web` to express type of resource requiring access to database"
}

variable "table_name" {
  description = "the name of the DynamoDB table"
}
