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


# APPLICATION SECRETS

variable "docker_build_args" {
  description = "a list of build args to be input when the Docker image is built"
  type = "list"
}

variable "datomic_uri" {
  description = "the uri used by this service to connect to the Datomic transactor"
}

variable "api_secrets" {
  description = "a map of API secrets used by this service"
  type = "map"
}


# PIPELINE SECRETS

variable "github_repo" {
  description = "github repository containing code for this service"
}

variable "github_branch" {
  description = "github branch watched for new commits as triggers to build and deploy"
}

variable "github_owner" {
  description = "github organization who owns the repo"
}

variable "github_oauth_token" {
  description = "github oauth token used for authentication to pull new code"
}
