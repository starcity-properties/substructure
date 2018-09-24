# INHERITED

variable "aws_region" {
  description = "aws region"
}


# REQUIRED GLOBAL

variable "github_ssh_keys" {
  description = "a map of Github usernames and SSH keys for those on the Starcity engineering team"
  type = "map"
}

variable "github_owner" {
  description = "github organization who owns the repo"
}

variable "github_oauth_token" {
  description = "github oauth token used for authentication to pull new code"
}
