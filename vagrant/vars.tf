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

variable "vpc_remote_state_key" {
  description = "key for the vpc remote state file"
}

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ssh_key_name" {
  description = "the name of the key pair associated with this instance"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_type" {
  description = "aws instance type"
  default     = "t2.micro"
}
