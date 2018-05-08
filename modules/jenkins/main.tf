# instance

resource "aws_instance" "jenkins" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  security_groups             = ["${aws_security_group.jenkins_inbound.id}"]
  associate_public_ip_address = true

  user_data = "${data.template_file.jenkins_user_data.rendered}"
  key_name  = "${var.key_name}"

  tags {
    Name = "Jenkins"
  }
}

data "template_file" "jenkins_user_data" {
  template = "${file("${path.module}/files/run-jenkins.sh")}"

  # vars {}
}

# security group

resource "aws_security_group" "jenkins_inbound" {
  name        = "jenkins_inbound"
  description = "Allow HTTP access from anywhere"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "jenkins_inbound"
  }
}

# security group rules

resource "aws_security_group_rule" "allow_http_jenkins_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.jenkins_inbound.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_jenkins_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.jenkins_inbound.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_jenkins_inbound_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.jenkins_inbound.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# SSH security group rule, TODO: expose via bastion! ---------------------------

resource "aws_security_group_rule" "allow_ssh_jenkins_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.jenkins_inbound.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # TODO: Lock this down!
}

# ------------------------------------------------------------------------------

resource "aws_security_group_rule" "allow_jenkins_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.jenkins_inbound.id}"

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# ami data source

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}
