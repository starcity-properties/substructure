resource "aws_security_group" "datomic_inbound" {
  name        = "datomic_inbound"
  description = "Allow SSH to Datomic Transactor host from approved ranges"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "datomic_inbound"
  }
}

resource "aws_security_group_rule" "allow_ssh_datomic_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.datomic_inbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_icmp_datomic" {
  type              = "ingress"
  security_group_id = "${aws_security_group.datomic_inbound.id}"

  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}
