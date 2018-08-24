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

variable "domain_name" {
  description = "This is the name of the hosted zone."
}

variable "name_servers" {
  description = "A list of name servers in associated (or default) delegation set."
  type = "list"
  default = []
}
