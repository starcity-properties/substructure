# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "aws_account_ids" {
  description = "aws account id's for all environments"
  type = "map"
}


<<<<<<< HEAD
# CALCULATED

<<<<<<< HEAD
=======
<<<<<<< HEAD
# CALCULATED

variable "aws_account_id" {
  description = "the aws account id for respective environment: development, staging, or production"
  default = "${lookup(var.aws_account_ids, var.environment, 'Not here!')}"
}


>>>>>>> separate global-iam declarations
=======
>>>>>>> remove merge conflicts
# REQUIRED ENVIRONMENT-SPECIFIC

variable "environment" {
  description = "environment, or aws account"
}

# TODO: move this to its proper place
variable "db_access_type" {
  description = "type of resource requiring db access: one of `app` (backend service) or `web` (web application)"
}

# TODO: move this to its proper place
variable "table_name" {
  description = "the name of the database table"
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# TODO: move this to its proper place
=======
=======
>>>>>>> add env -> account-id vars; cleanup
=======
variable "aws_account_id" {
  description = "the aws account id for respective environment: development, staging, or production"
}

>>>>>>> separate global-iam declarations
>>>>>>> separate global-iam declarations
variable "iam_policy_arns" {
  description = "list of policies to be attached to a role for a backend service or web application"
  type = "list"
  default = []
}

variable "table_name" {
  description = "the name of the DynamoDB table"
=======
=======
>>>>>>> remove merge conflicts
variable "iam_policy_arns" {
  description = "list of policies to be attached to a role"
  type = "list"
}
