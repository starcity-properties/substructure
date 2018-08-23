# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "iam_global_remote_state_key" {
  description = "key of the iam global remote state within `tfstate_bucket`"
}

variable "tfstate_bucket" {
  description = "bucket to find the remote terraform state"
}

variable "tfstate_region" {
  description = "region of the remote terraform state bucket"
}


# REQUIRED

variable "keybase_identities" {
  description = "map of AWS user to keybase.io identity"
  type = "map"
  default = {}
}
