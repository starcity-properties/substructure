terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*==== Casbah host ======*/

data "aws_ami" "lein_ami" {
  filter {
    name   = "name"
    values = ["leiningen-2.8.1-default-*"]
  }
}


# provisioning script

data "template_file" "casbah_user_data" {
  template = "${file("${path.module}/scripts/provision.sh")}"
}


# Casbah instance

resource "aws_instance" "casbah" {
  key_name               = "${var.ssh_key_name}"
  ami                    = "${data.aws_ami.lein_ami.image_id}"
  instance_type          = "${var.instance_type}"

  user_data = "${data.template_file.casbah_user_data.rendered}"

  subnet_id              = "${element(data.terraform_remote_state.vpc.public_subnet_ids, 0)}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.casbah_inbound_id}",
    "${data.terraform_remote_state.vpc.casbah_outbound_id}"
  ]

  associate_public_ip_address = false

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("${var.key_path}")}"
    agent       = false
  }

  tags {
    Name = "casbah_host"
  }
}


resource "aws_route53_record" "casbah" {
  name    = "${var.route53_subdomain_prefix}.${data.terraform_remote_state.route53.route53_private_zone_name}"
  zone_id = "${data.terraform_remote_state.route53.route53_private_zone_id}"
  type    = "A"
  ttl     = "300"

  records = ["${aws_instance.casbah.private_ip}"]
}
