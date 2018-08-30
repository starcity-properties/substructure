# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "aws_account_ids" {
  description = "aws account id's for all environments"
  type = "map"
}


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

# TODO: move this to its proper place
variable "iam_policy_arns" {
  description = "list of policies to be attached to a role for a backend service or web application"
  type = "list"
  default = []
}
