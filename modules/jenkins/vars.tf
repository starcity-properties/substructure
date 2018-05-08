variable "subnet_id" {
  description = "the vpc subnet to use. defaults to ..."
  default     = ""
}

variable "vpc_id" {
  description = "id of the vpc to install into. defaults to default vpc."
}

variable "instance_type" {
  description = "type of the ec2 instance"
}

variable "key_name" {
  description = "name of the ssh key for the instance"
}
