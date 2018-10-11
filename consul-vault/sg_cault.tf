# ---------------------------------------------------------------------------------------------------------------------
# ELB && RULES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "elb_cault" {
  name        = "elb-cault"
  description = "Allow ELB (Consul / Vault) access from and to approved ranges"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "elb-${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "allow_http_api_inbound" {
  security_group_id = "${aws_security_group.elb_cault.id}"
  type              = "ingress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = "${var.elb_port}"
  to_port   = "${var.elb_port}"
  protocol  = "tcp"
}

resource "aws_security_group_rule" "allow_http_api_outbound" {
  security_group_id = "${aws_security_group.elb_cault.id}"
  type              = "egress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = "${var.http_api_port}"
  to_port   = "${var.http_api_port}"
  protocol  = "tcp"
}

# ---------------------------------------------------------------------------------------------------------------------
# EC2 INBOUND
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "cault_inbound" {
  name        = "cault-inbound"
  description = "Allow Consul / Vault EC2 instances access from approved ranges"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.cluster_name}-inbound"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# EC2 INBOUND RULES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "allow_icmp_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.cault_inbound.id}"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = 8
  to_port   = 0
  protocol  = "icmp"
}

resource "aws_security_group_rule" "allow_ssh_inbound_from_cidr_blocks" {
  security_group_id = "${aws_security_group.cault_inbound.id}"
  type              = "ingress"

  cidr_blocks = ["${var.allowed_ssh_cidr_blocks}"]

  from_port   = "${var.ssh_port}"
  to_port     = "${var.ssh_port}"
  protocol    = "tcp"
}

resource "aws_security_group_rule" "allow_ssh_inbound_from_security_group_id" {
  security_group_id = "${aws_security_group.cault_inbound.id}"
  type              = "ingress"

  source_security_group_id = "${data.terraform_remote_state.vpc.bastion_outbound_id}"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "tcp"
}

resource "aws_security_group_rule" "allow_http_api_inbound_from_elb" {
  security_group_id = "${aws_security_group.cault_inbound.id}"
  type              = "ingress"

  cidr_blocks = ["${var.allowed_ssh_cidr_blocks}"]
  # source_security_group_id = "${data.terraform_remote_state.vpc.bastion_inbound_id}"

  from_port = "${var.http_api_port}"
  to_port   = "${var.http_api_port}"
  protocol  = "tcp"
}

resource "aws_security_group_rule" "allow_cluster_inbound_from_self" {
  security_group_id = "${aws_security_group.cault_inbound.id}"
  self      = true
  type      = "ingress"

  from_port = "${var.cluster_self}"
  to_port   = "${var.cluster_self}"
  protocol  = "tcp"
}

# ---------------------------------------------------------------------------------------------------------------------
# EC2 OUTBOUND
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "cault_outbound" {
  name        = "cault-outbound"
  description = "Allow Consul / Vault EC2 instances access to approved ranges"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.cluster_name}-outbound"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# EC2 OUTBOUND RULES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "allow_all_outbound" {
  security_group_id = "${aws_security_group.cault_inbound.id}"
  type              = "egress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
}
