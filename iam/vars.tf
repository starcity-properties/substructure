# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "aws_account_ids" {
  description = "aws account id's for all environments"
  type = "map"
}


# CALCULATED

<<<<<<< HEAD
# CALCULATED

variable "aws_account_id" {
  description = "the aws account id for respective environment: development, staging, or production"
  default = "${lookup(var.aws_account_ids, var.environment, 'Not here!')}"
}


# REQUIRED ENVIRONMENT-SPECIFIC

variable "environment" {
  description = "environment, or aws account"
}

variable "db_access_type" {
  description = "one of `app` (backend service) or `web` to express type of resource requiring access to database"
}

variable "table_name" {
  description = "the name of the database table"
}

<<<<<<< HEAD
=======
variable "aws_account_id" {
  description = "the aws account id for respective environment: development, staging, or production"
}

>>>>>>> separate global-iam declarations
variable "iam_policy_arns" {
  description = "list of policies to be attached to a role"
  type = "list"
}

variable "table_name" {
  description = "the name of the DynamoDB table"
=======
variable "iam_policy_arns" {
  description = "list of policies to be attached to a role"
  type = "list"
>>>>>>> add env -> account-id vars; cleanup
}
