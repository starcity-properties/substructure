# INHERITED

variable "aws_region" {
  description = "aws region"
}

variable "vpc_remote_state_key" {
  description = "key for the vpc remote state file"
}

variable "iam_remote_state_key" {
  description = "key for the iam remote state file"
}

variable "tfstate_bucket" {
  description = "bucket that terraform remote state is stored in"
}

variable "tfstate_region" {
  description = "region of the tfstate_global_bucket"
}


# DTX-SPECIFIC

variable "protocol" {
  description = "storage protocol to use"
  default     = "ddb"
}

variable "port" {
  description = "port"
}

variable "availability_zones" {
  type        = "list"
  description = "zones in which to make the transactor available"
}

variable "transactor_name" {
  description = "name of the datomic transactor"
}

variable "instance_type" {
  description = "aws instance type for the transactor instance"
}

variable "instance_count" {
  description = "number of datomic transactor instances"
  default     = 1
}

variable "transactor_memory_index_max" {
  default     = "512m"
  description = "TODO:"
}

variable "transactor_memory_index_threshold" {
  default     = "16m"
  description = "TODO:"
}

variable "transactor_object_cache_max" {
  default     = "64m"
  description = "TODO:"
}

variable "java_opts" {
  description = "java options to run transactor"
}

variable "transactor_xmx" {
  description = "max transactor memory consumption"
}

variable "transactor_xms" {
  description = "initial transactor memory consumption"
}

variable "license_key" {
  description = "license for datomic pro"
}

variable "transactor_java_opts" {
  description = "additional jvm options to pass"
  default     = ""
}

variable "cloudwatch_dimension" {
  default     = "Datomic"
  description = "TODO:"
}

variable "partition" {
  description = "name of database partition"
}

# variable "memcached_uri" {}

variable "ssh_key_name" {
  description = "name of the ec2 keypair to use"
}

variable "dynamodb_table" {
  description = "dynamodb table to store datomic data"
}

variable "db_name" {
  description = "database name"
}

variable "dynamo_read_capacity" {
  description = "read capacity for dynamodb"
}

variable "dynamo_write_capacity" {
  description = "write capacity for dynamodb"
}
