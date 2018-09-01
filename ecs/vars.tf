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

variable "ecr_remote_state_key" {
  description = "key of the ecr remote state within `tfstate_bucket`"
}

variable "iam_remote_state_key" {
  description = "key of the iam remote state within `tfstate_bucket`"
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

variable "db_access_type" {
  description = "TODO"
}

variable "desired_count" {
  description = "TODO"
}

variable "cpu" {
  description = "cpu power"
}

variable "memory" {
  description = "memory allocation"
}

variable "protocol" {
  description = "port mapping protocol"
}

variable "container_port" {
  description = "container port"
}

variable "host_port" {
  description = "host port"
}
