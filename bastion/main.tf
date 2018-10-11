# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*==== Bastion host ======*/

data "aws_ami" "bastion_host" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bastion-default-*"]
  }
}


# provisioning script

data "template_file" "bastion_user_data" {
  template = "${file("${path.module}/scripts/provision.sh")}"

  # TODO use a map of users and keys, pass in each to the script
  vars {
    users = "${var.users}"
  }
}


# Bastion instance

resource "aws_instance" "bastion" {
  key_name      = "${var.ssh_key_name}"
  ami           = "${data.aws_ami.bastion_host.image_id}"
  instance_type = "${var.instance_type}"

  user_data = "${data.template_file.bastion_user_data.rendered}"

  subnet_id              = "${element(data.terraform_remote_state.vpc.public_subnet_ids, 0)}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.bastion_inbound_id}",
    "${data.terraform_remote_state.vpc.bastion_outbound_id}"
  ]

  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.key_path}")}"
    agent       = false
  }

  provisioner "file" {
    source      = "${path.module}/keys/authorized_keys"
    destination = "/tmp/authorized_keys"
  }

  provisioner "file" {
    source      = "${path.module}/keys/casbah_authorized_keys"
    destination = "/tmp/casbah_authorized_keys"
  }

  # TODO: this set of commands currently requires a manual process in order to finish getting authorized_keys onto private server

  # provisioner "local-exec" {
  #   command = "scp -i ${file("${var.key_path}")} /.aws/casbah.pem ubuntu@${aws_instance.bastion.public_dns}:~/.ssh/casbah.pem"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "scp -i ~/.ssh/casbah.pem /tmp/casbah_authorized_keys ec2-user@${data.terraform_remote_state.casbah.casbah_private_ip}:~/.ssh/authorized_keys"
  #   ]
  # }

  tags {
    Name = "bastion_host"
  }
}


resource "aws_route53_record" "bastion" {
  name    = "${var.route53_subdomain_prefix}.${data.terraform_remote_state.route53.route53_public_zone_name}"
  zone_id = "${data.terraform_remote_state.route53.route53_public_zone_id}"
  type    = "A"
  ttl     = "300"

  records = ["${aws_instance.bastion.public_ip}"]
}
