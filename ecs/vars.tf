# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "environment" {
  description = "environment, or aws account"
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


# ECS-SPECIFIC

variable "repository_name" {
  description = "The repository that holds our Docker images."
}

variable "cpu" {
  description = "cpu power"
  default = "256"
}

variable "memory" {
  description = "memory allocation"
  default = "512"
}
