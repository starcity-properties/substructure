variable "aws_region" {
  description = "aws region to launch in"
}

# variable "tfstate_bucket" {
#   description = "bucket to find the remote terraform state"
# }

# variable "tfstate_region" {
#   description = "region of the remote terraform state bucket"
# }

# variable "vpc_remote_state_key" {
#   description = "key of the vpc remote state within `tfstate_bucket`"
# }

variable "vpc_id" {
  description = "id of the vpc to install into. defaults to default vpc."
  default     = ""
}

variable "instance_type" {
  description = "type of the ec2 instance"
}

variable "key_name" {
  description = "name of the ssh key for the instance"
}
