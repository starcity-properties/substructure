# ---------------------------------------------------------------------------------------------------------------------
# INHERITED PARAMETERS
# These parameters extend across modules.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "aws region"
}

variable "tfstate_bucket" {
  description = "bucket that terraform remote state is stored in"
}

variable "tfstate_region" {
  description = "region of the tfstate_global_bucket"
}

variable "casbah_remote_state_key" {
  description = "key for the casbah remote state file"
}

variable "vpc_remote_state_key" {
  description = "key for the vpc remote state file"
}

variable "route53_remote_state_key" {
  description = "key for the route53 remote state file"
}

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ssh_key_name" {
  description = "the name of the key pair associated with this instance"
}

variable "key_path" {
  description = "the absolute path to the .pem key"
}

variable "users" {
  description = "users to be created on bastion"
}

# TODO: make this a map of users and keys so that authorized keys can be passed in via superstructure
# variable "public_keys" {
#   description = "public keys to be loaded onto bastion"
#   default     = {}
#   type        = "map"
# }

# TODO
variable "route53_subdomain_prefix" {
  description = "the prefix of the record name to create the subdomain"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_type" {
  description = "aws instance type"
  default     = "t2.micro"
}
