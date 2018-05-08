resource "aws_security_group" "bastion_inbound" {
  name        = "bastion_inbound"
  description = "Allow SSH to Bastion host from approved ranges"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "bastion_inbound"
  }
}

resource "aws_security_group_rule" "allow_ssh_bastion_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.bastion_inbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_bastion_inbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.bastion_inbound.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_icmp_8_bastion_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.bastion_inbound.id}"

  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "bastion_outbound" {
  name        = "bastion_outbound"
  description = "Allow SSH from Bastion host(s)"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "bastion_outbound"
  }
}

resource "aws_security_group_rule" "allow_ssh_bastion_outbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.bastion_outbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = "${var.bastion_ssh_cidr_blocks}"
}
