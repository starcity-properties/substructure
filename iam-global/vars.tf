# INHERITED

variable "aws_region" {
  description = "aws region"
}



# REQUIRED GLOBAL

variable "applications" {
  type = "list"
  default = []
}

variable "developers" {
  type = "list"
  default = []
}

variable "administrators" {
  type = "list"
  default = []
}

variable "dev_account" {
  description = "number associated with aws development account (role)"
}

variable "stage_account" {
  description = "number associated with aws staging account (role)"
}

variable "prod_account" {
  description = "number associated with aws production account (role)"
}
