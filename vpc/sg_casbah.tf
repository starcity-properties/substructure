resource "aws_security_group" "casbah_inbound" {
  name        = "casbah_inbound"
  description = "Allow SSH to Casbah host from approved ranges"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "casbah_inbound"
  }
}

resource "aws_security_group_rule" "allow_ssh_casbah_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.casbah_inbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_icmp_casbah" {
  type              = "ingress"
  security_group_id = "${aws_security_group.casbah_inbound.id}"

  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "casbah_outbound" {
  name        = "casbah_outbound"
  description = "Allow SSH from Casbah host(s)"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "casbah_outbound"
  }
}

resource "aws_security_group_rule" "allow_ssh_casbah_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.casbah_outbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
