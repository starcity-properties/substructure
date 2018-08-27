# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "vpc_remote_state_key" {
  description = "key of the vpc remote state within `tfstate_bucket`"
}

variable "tfstate_bucket" {
  description = "bucket to find the remote terraform state"
}

variable "tfstate_region" {
  description = "region of the remote terraform state bucket"
}


# REQUIRED

variable "environment" {
  description = "environment, or aws account"
}

variable "domain_name" {
  description = "the registered domain name"
}

variable "route53_sub_domains" {
  description = "a list of subdomains to be created in this environment"
  type = "list"
  default = []
}
