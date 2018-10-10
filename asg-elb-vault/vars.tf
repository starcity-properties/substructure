variable "tfstate_bucket" {
  description = "bucket to find the remote terraform state"
}

variable "tfstate_region" {
  description = "region of the remote terraform state bucket"
}

variable "vpc_remote_state_key" {
  description = "key of the vpc remote state within `tfstate_bucket`"
}


variable "aws_region" {
  description = "aws region to launch in"
}

variable "ami" {
  description = "The AMI to run in the cluster"
}

variable "service_name" {
  description = "The name to use for all the cluster resources"
}

variable "server_port" {
  description = "The port that the web service will be running on"
}

variable "instance_type" {
  description = "The type of EC2 instances to run"
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
}

variable "key_name" {
  default = "cault"
}
