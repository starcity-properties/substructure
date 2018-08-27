/*====
ECS service -- security group
======*/


resource "aws_security_group" "ecs_service" {
  name        = "vpc-ecs-service-sg"
  description = "Allow egress from container"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags {
    Name        = "vpc-ecs-service-sg"
  }
}

resource "aws_security_group_rule" "ecs_allow_icmp_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.ecs_service.id}"

  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_allow_http_egress_inbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.ecs_service.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


/*====
LB -- security group
======*/


resource "aws_security_group" "web_inbound_sg" {
  name        = "vpc-web-inbound-sg"
  description = "Allow HTTP from Anywhere into LB"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags {
    Name = "${var.environment}-web-inbound-sg"
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = "${aws_security_group.web_inbound_sg.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_icmp_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.web_inbound_sg.id}"

  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_egress_inbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.web_inbound_sg.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
