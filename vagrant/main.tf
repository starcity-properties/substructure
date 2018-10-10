# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


# provisioning script

data "template_file" "vagrant_user_data" {
  template = "${file("${path.module}/scripts/provision.sh")}"

  # TODO turn this into a map of users and ssh keys
  vars {
    users = "${var.users}"
  }
}


# vagrant instance

resource "aws_instance" "vagrant" {
  key_name      = "${var.ssh_key_name}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"

  user_data = "${data.template_file.vagrant_user_data.rendered}"

  subnet_id              = "${data.terraform_remote_state.vagrant.vagrant_subnet_id}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.vagrant_inbound_id}",
    "${data.terraform_remote_state.vpc.vagrant_outbound_id}"
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

  tags {
    Name = "vagrant_host"
  }
}