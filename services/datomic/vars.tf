# =============================================================
# Inherited
# =============================================================

variable "aws_region" {
  description = "aws region"
}

variable "aws_account_ids" {
  description = "aws account id's for all environments"
  type = "map"
}

variable "tfstate_bucket" {
  description = "bucket that terraform remote state is stored in"
}

variable "tfstate_region" {
  description = "region of the tfstate_global_bucket"
}

//variable "vpc_remote_state_key" {
//  description = "key for the vpc remote state file"
//}

variable "iam_remote_state_key" {
  description = "key for the IAM remote state file"
}

# =============================================================
# DynamoDB (inherited)
# =============================================================

variable "ddb_datomic_kv_table" {
  description = "DynamoDB table for Datomic key values."
}

variable "ddb_read_capacity" {
  description = "DynamoDB read capacity."
}

variable "ddb_write_capacity" {
  description = "DyanmoDB write capacity."
}

variable "dynamodb_remote_state_key" {
  description = "Terraform remote state file key for DynamoDB."
}

# =============================================================
# Datomic (inherited)
# =============================================================


# Env

variable "datomic_license_key" {
  description = "License key for Datomic Pro (obtained from my.datomic.com)"
}

variable "instance_type" {
  description = "EC2 instance type Datomic will run on."
}

variable "instance_count" {
  description = "number of datomic transactor instances"
  default     = 1
}

variable "availability_zones" {
  type        = "list"
  description = "zones in which to make the transactor available"
}

# Datomic config

variable "datomic_ami" {
  description = "storage protocol to use"
}

variable "datomic_protocol" {
  description = "storage protocol to use"
  default     = "ddb"
}

variable "datomic_port" {
  description = "port"
}


variable "datomic_partition" {
  description = "name of database partition"
}

variable "datomic_db_name" {
  description = "database name"
}

# Transactor properties

variable "transactor_name" {
  description = "name of the datomic transactor"
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

//variable "license_key" {
//  description = "License key for Datomic Pro (obtained from my.datomic.com)"
//}

variable "transactor_java_opts" {
  description = "additional jvm options to pass"
  default     = ""
}

variable "cloudwatch_dimension" {
  default     = "Datomic"
  description = "TODO:"
}


# variable "memcached_uri" {}

variable "ssh_key_name" {
  description = "name of the ec2 keypair to use"
}

//variable "dynamodb_table" {
//  description = "dynamodb table to store datomic data"
//}



//variable "dynamo_read_capacity" {
//  description = "read capacity for dynamodb"
//}
//
//variable "dynamo_write_capacity" {
//  description = "write capacity for dynamodb"
//}