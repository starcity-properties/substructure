# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


# bastion instance

data "template_file" "bastion_user_data" {
  template = "${file("${path.module}/scripts/provision.sh")}"

  vars {
    users = "${var.users}"
  }
}


resource "aws_instance" "bastion" {
  key_name      = "${var.ssh_key_name}"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

  subnet_id              = "${element(data.terraform_remote_state.vpc.public_subnet_ids, 0)}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.bastion_inbound_id}",
    "${data.terraform_remote_state.vpc.bastion_outbound_id}"
  ]

  user_data = "${data.template_file.bastion_user_data.rendered}"

  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.key_path}")}"
    agent       = false
  }

  provisioner "file" {
    source      = "${path.module}/scripts/authorized_keys"
    destination = "/tmp/authorized_keys"
  }

  tags {
    Name = "bastion_host"
  }
}
