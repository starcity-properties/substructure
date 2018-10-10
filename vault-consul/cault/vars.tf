# ---------------------------------------------------------------------------------------------------------------------
# INHERITED PARAMETERS
# These parameters extend across modules.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "aws region"
}

variable "vpc_remote_state_key" {
  description = "key of the vpc remote state within `tfstate_bucket`"
}

variable "iam_remote_state_key" {
  description = "key of the iam remote state within `tfstate_bucket`"
}

variable "route53_remote_state_key" {
  description = "key of the route53 remote state within `tfstate_bucket`"
}

variable "tfstate_bucket" {
  description = "bucket to find the remote terraform state"
}

variable "tfstate_region" {
  description = "region of the remote terraform state bucket"
}

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
}

variable "cluster_name" {
  description = "The name of the Vault-Consul cluster. This variable is used to namespace all resources created by this module."
}

variable "ami_id" {
  description = "The ID of the AMI to run in this cluster."
}

variable "instance_type" {
  description = "The type of EC2 Instances to run for each node in the cluster (e.g. t2.micro)."
}

variable "create_dns_entry" {
  description = "If set to true, this module will create a Route 53 DNS A record for the ELB in the var.hosted_zone_id hosted zone with the domain name in var.cault_domain_name."
}

variable "cault_domain_name" {
  description = "The domain name to use in the DNS A record for the Vault-Consul ELB (e.g. cault.example.com). Only used if var.create_dns_entry is true."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "vault_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  default     = "vault-cluster"
}

variable "consul_cluster_name" {
  description = "What to name the Consul server cluster and all of its associated resources"
  default     = "consul-cluster"
}

variable "cluster_size" {
  description = "The number of Vault-Consul server nodes to deploy. We strongly recommend either 3 or 5."
  default     = 3
}

variable "allowed_http_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Consul"
  type        = "list"
  default     = []
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow SSH connections"
  type        = "list"
  default     = []
}

# variable "allowed_ssh_security_group_ids" {
#   description = "A list of security group IDs from which the EC2 Instances will allow SSH connections"
#   type        = "list"
#   default     = []
# }

variable "associate_public_ip_address" {
  description = "If set to true, associate a public IP address with each EC2 Instance in the cluster."
  default     = "0"
}

variable "spot_price" {
  description = "The maximum hourly price to pay for EC2 Spot Instances."
  default     = ""
}

variable "tenancy" {
  description = "The tenancy of the instance. Must be one of: empty string, default or dedicated. For EC2 Spot Instances only empty string or dedicated can be used."
  default     = ""
}

variable "root_volume_ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized."
  default     = false
}

variable "root_volume_type" {
  description = "The type of volume. Must be one of: standard, gp2, or io1."
  default     = "standard"
}

variable "root_volume_size" {
  description = "The size, in GB, of the root EBS volume."
  default     = 50
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default."
  default     = "Default"
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

variable "health_check_type" {
  description = "Controls how health checking is done. Must be one of EC2 or ELB."
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time, in seconds, after instance comes into service before checking health."
  default     = 300
}

variable "instance_profile_path" {
  description = "Path in which to create the IAM instance profile."
  default     = "/"
}

variable "dns_port" {
  description = "The port used to resolve DNS queries."
  default     = 8600
}

variable "server_rpc_port" {
  description = "The port used by servers to handle incoming requests from other agents."
  default     = 8300
}

variable "cli_rpc_port" {
  description = "The port used by all agents to handle RPC from the CLI."
  default     = 8400
}

variable "serf_lan_port" {
  description = "The port used to handle gossip in the LAN. Required by all agents."
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by servers to gossip over the WAN to other servers."
  default     = 8302
}

variable "http_api_port" {
  description = "The port used by clients to talk to the HTTP API."
  default     = 8500
}

variable "cluster_self" {
  description = "The port used by nodes in cluster to talk amongst themselves."
  default     = 8201
}

variable "elb_port" {
  description = "The port used for ELB connections."
  default     = 80
}

variable "ssh_port" {
  description = "The port used for SSH connections."
  default     = 22
}

variable "cluster_tag_key" {
  description = "Add a tag with this key and the value var.cluster_tag_value to each Instance in the ASG. This can be used to automatically find other Consul nodes and form a cluster."
  default     = "consul-vault-servers"
}

variable "cluster_tag_value" {
  description = "Add a tag with key var.cluster_tag_key and this value to each Instance in the ASG. This can be used to automatically find other Consul nodes and form a cluster."
  default     = "auto-join"
}

# ELB

variable "internal" {
  description = "If true, ELB will be an internal ELB."
  default     = true
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing. Default: true."
  default     = true
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Default: 60."
  default     = 400
}

variable "connection_draining" {
  description = "Boolean to enable connection draining. Default: false."
  default     = true
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain. Default: 300."
  default     = 400
}

variable "health_check_protocol" {
  description = "The PROTOCOL of the target of the check."
  default     = "tcp"
}

variable "health_check_path" {
  description = "The PATH of the target of the check. With HTTP, HTTPS - PORT and PATH are required. WIth TCP, SSL - PORT is required, PATH is not supported."
  default     = "health"
}

variable "health_check_interval" {
  description = "The interval between checks."
  default     = 30
}

variable "health_check_healthy_threshold" {
  description = "The number of checks before the instance is declared healthy."
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of checks before the instance is declared unhealthy."
  default     = 2
}

variable "health_check_timeout" {
  description = "The length of time before the check times out."
  default     = 3
}
