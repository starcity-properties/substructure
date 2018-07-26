variable "aws_region" {
  description = "aws region"
}

variable "cidr" {
  description = "cidr for the vpc"
}

variable "availability_zones" {
  type        = "list"
  description = "availability zones for the vpc"
}

variable "enable_dns_hostnames" {
  description = "TODO:"
  default     = true
}

variable "enable_dns_support" {
  description = "TODO:"
  default     = true
}

variable "ip_range" {
  description = "TODO:"
}

variable "public_ranges" {
  type        = "list"
  description = "the public ip ranges"
}

variable "private_ranges" {
  type        = "list"
  description = "the private ip ranges"
}

variable "internal_cidr_blocks" {
  description = "internal cidr blocks for security group rules"
  type        = "list"
}

variable "bastion_ssh_cidr_blocks" {
  description = "bastion cidr blocks for ssh security group rule"
  type        = "list"
}
