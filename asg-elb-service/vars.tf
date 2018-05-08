variable "aws_region" {
  description = "aws region to launch in"
}

variable "ami" {
  description = "The AMI to run in the cluster"
}

variable "service_name" {
  description = "The name to use for all the cluster resources"
}

# variable "service_version" {
#   description = "The version number of the service to deploy"
# }

# variable "releases_bucket" {
#   description = "The name of the S3 bucket that release artifacts are found in"
# }

# variable "release_artifact" {
#   description = "The name of the release artifact"
# }

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

variable "tfstate_bucket" {
  description = "bucket to find the remote terraform state"
}

variable "tfstate_region" {
  description = "region of the remote terraform state bucket"
}

variable "vpc_remote_state_key" {
  description = "key of the vpc remote state within `tfstate_bucket`"
}

variable "codedeploy_remote_state_key" {
  description = "key of the codedeploy remote state within `tfstate_bucket`"
}

variable "rollback_enabled" {
  description = "Whether to enable auto rollback"
  default     = false
}

variable "rollback_events" {
  description = "The event types that trigger a rollback"
  type        = "list"
  default     = ["DEPLOYMENT_FAILURE"]
}

# --- debug ---

variable "key_name" {
  default = "jenkins"
}
