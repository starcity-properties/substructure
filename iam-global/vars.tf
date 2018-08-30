# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "aws_account_ids" {
  description = "aws account id's for all environments"
  type = "map"
}


# REQUIRED GLOBAL

variable "applications" {
  type = "map"
  default = {}
}

variable "administrators" {
  type = "map"
  default = {}
}

variable "developers" {
  type = "map"
  default = {}
}
