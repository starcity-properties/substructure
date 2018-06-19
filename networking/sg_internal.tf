resource "aws_security_group" "internal_inbound" {
  name        = "internal_inbound"
  description = "Allow access to apps on internal subnets from internal addresses"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "internal_inbound"
  }
}

resource "aws_security_group_rule" "allow_ssh_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_http_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_https_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_health_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_app_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_datomic_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 4334
  to_port     = 4334
  protocol    = "tcp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_statsd_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 2185
  to_port     = 2185
  protocol    = "udp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_icmp_internal_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_http_egress_internal_inbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.internal_inbound.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
