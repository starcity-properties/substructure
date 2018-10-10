terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

#---#---#---#

data "aws_ami" "cault_ami" {
  filter {
    name   = "name"
    values = ["docker-compose-star-development"]
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN AUTO SCALING GROUP (ASG) TO RUN CONSUL
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "consul_vault_cluster" {
  name_prefix = "${var.cluster_name}-"

  launch_configuration = "${aws_launch_configuration.consul_vault.name}"

  availability_zones  = [
    "${element(data.terraform_remote_state.vpc.availability_zones, 0)}",
    "${element(data.terraform_remote_state.vpc.availability_zones, 1)}",
    "${element(data.terraform_remote_state.vpc.availability_zones, 2)}"
  ]

  vpc_zone_identifier = [
    "${element(data.terraform_remote_state.vpc.private_subnet_ids, 0)}",
    "${element(data.terraform_remote_state.vpc.private_subnet_ids, 1)}",
    "${element(data.terraform_remote_state.vpc.private_subnet_ids, 2)}"
  ]

  # Run a fixed number of instances in the ASG
  min_size             = "${var.cluster_size}"
  max_size             = "${var.cluster_size}"
  desired_capacity     = "${var.cluster_size}"
  termination_policies = ["${var.termination_policies}"]

  health_check_type         = "${var.health_check_type}"
  health_check_grace_period = "${var.health_check_grace_period}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}"
      propagate_at_launch = true
    },
    {
      key                 = "${var.cluster_tag_key}"
      value               = "${var.cluster_tag_value}"
      propagate_at_launch = true
    }
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE LAUNCH CONFIGURATION TO DEFINE WHAT RUNS ON EACH INSTANCE IN THE ASG
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_configuration" "consul_vault" {
  name_prefix = "${var.cluster_name}-"

  image_id      = "${data.aws_ami.cault_ami.image_id}"
  instance_type = "${var.instance_type}"

  spot_price        = "${var.spot_price}"
  placement_tenancy = "${var.tenancy}"

  iam_instance_profile = "${data.terraform_remote_state.iam.consul_vault_profile}"
  security_groups      = [
    "${aws_security_group.cault_inbound.id}",
    "${aws_security_group.cault_outbound.id}"
  ]

  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.ssh_key_name}"

  ebs_optimized = "${var.root_volume_ebs_optimized}"

  root_block_device {
    volume_type           = "${var.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = "${var.root_volume_delete_on_termination}"
  }

  # Important note: whenever using a launch configuration with an auto scaling group, you must set
  # create_before_destroy = true. However, as soon as you set create_before_destroy = true in one resource, you must
  # also set it in every resource that it depends on, or you'll get an error about cyclic dependencies (especially when
  # removing resources). For more info, see:

  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  # https://terraform.io/docs/configuration/resources.html

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ELB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elb" "cault" {
  name = "consul-vault-elb"

  internal                    = "${var.internal}"
  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  subnets         = [
    "${element(data.terraform_remote_state.vpc.public_subnet_ids, 0)}",
    "${element(data.terraform_remote_state.vpc.public_subnet_ids, 1)}",
    "${element(data.terraform_remote_state.vpc.public_subnet_ids, 2)}"
  ]
  security_groups = [
    "${aws_security_group.elb_cault.id}"
  ]

  # TODO: add s3 bucket permissions to store access logs
  # access_logs {
  #   bucket        = "${aws_s3_bucket.elb_access_logs.bucket}"
  #   bucket_prefix = "cault-"
  #   interval      = 60
  # }

  # Run the ELB in TCP passthrough mode
  listener {
    lb_port           = "${var.elb_port}"
    lb_protocol       = "tcp"
    instance_port     = "${var.http_api_port}"
    instance_protocol = "tcp"
  }

  health_check {
    target              = "${var.health_check_protocol}:${var.http_api_port}"
    interval            = "${var.health_check_interval}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
  }

  tags {
    Name = "vault-elb"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH THE ELB TO THE VAULT ASG
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_attachment" "cault" {
  autoscaling_group_name = "${aws_autoscaling_group.consul_vault_cluster.name}"
  elb                    = "${aws_elb.cault.id}"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONALLY CREATE A ROUTE 53 ENTRY FOR THE ELB
# ---------------------------------------------------------------------------------------------------------------------

# resource "aws_route53_record" "cault_elb" {
#   count = "${var.create_dns_entry}"

#   zone_id = "${data.terraform_remote_state.route53.route53_zone_id_dev}"
#   name    = "${var.cault_domain_name}"
#   type    = "A"

#   alias {
#     name    = "${aws_elb.cault.dns_name}"
#     zone_id = "${aws_elb.cault.zone_id}"

#     # When set to true, if either none of the ELB's EC2 instances are healthy or the ELB itself is unhealthy,
#     # Route 53 routes queries to "other resources." But since we haven't defined any other resources, we'd rather
#     # avoid any latency due to switchovers and just wait for the ELB and Vault instances to come back online.
#     # For more info, see http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-alias.html#rrsets-values-alias-evaluate-target-health
#     evaluate_target_health = false
#   }
# }

resource "aws_s3_bucket" "elb_access_logs" {
  bucket = "starcity-cault-elb-access-logs"
  acl    = "private"
}
