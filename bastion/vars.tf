# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "tfstate_bucket" {
  description = "bucket that terraform remote state is stored in"
}

variable "tfstate_region" {
  description = "region of the tfstate_global_bucket"
}

variable "vpc_remote_state_key" {
  description = "key for the vpc remote state file"
}


# BASTION

variable "ami" {
  description = "ami to use for the instance"
  default     = "ami-b55232cd"
}

variable "instance_type" {
  description = "aws instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "the name of the key pair associated with this instance"
}

variable "users" {
  description = "users to be created on bastion"
}


# TODO
# variable "public_keys" {
#   description = "public keys to be loaded onto bastion"
#   default     = {}
#   type        = "map"
# }


# TODO
variable "route53_subdomain" {
  description = "the name of the record"
}
