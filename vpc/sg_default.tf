/*====
VPC's Default Security Group
======*/

resource "aws_security_group" "default" {
  name        = "vpc-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = ["aws_vpc.vpc"]
}

resource "aws_security_group_rule" "allow_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.default.id}"

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = true
}

resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.default.id}"

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = "true"
}
