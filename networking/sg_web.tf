resource "aws_security_group" "web_inbound" {
  name        = "web_inbound"
  description = "Allow HTTP from Anywhere"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "web_inbound"
  }
}

resource "aws_security_group_rule" "allow_http_web_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.web_inbound.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_web_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.web_inbound.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# for TCP-based ELB health-checks
resource "aws_security_group_rule" "allow_health_web_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.web_inbound.id}"

  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_icmp_web_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.web_inbound.id}"

  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_web_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.web_inbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = "${var.internal_cidr_blocks}"
}

resource "aws_security_group_rule" "allow_http_web_inbound_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.web_inbound.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
