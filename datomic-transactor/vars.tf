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

variable "ami" {
  description = "ami to use for transactor instance"
}

variable "protocol" {
  description = "storage protocol to use"
  default     = "ddb"
}

variable "availability_zones" {
  type        = "list"
  description = "zones in which to make the transactor available"
}

variable "transactor_name" {
  description = "name of the datomic transactor"
}

variable "transactor_instance_type" {
  description = "aws instance type for the transactor instance"
  default     = "t2.micro"
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

variable "transactor_xmx" {
  description = "max transactor memory consumption"
}

variable "datomic_license" {
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

variable "key_name" {
  description = "name of the ec2 keypair to use"
}

variable "dynamodb_table" {
  description = "dynamodb table to store datomic data"
}

variable "dynamo_read_capacity" {
  description = "read capacity for dynamodb"
  default     = 1
}

variable "dynamo_write_capacity" {
  description = "write capacity for dynamodb"
  default     = 1
}
