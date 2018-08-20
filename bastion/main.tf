# setup

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


# provisioning script

data "template_file" "bastion_user_data" {
  template = "${file("${path.module}/scripts/provision.sh")}"

  vars {
    users = "${var.users}"
  }
}


# bastion instance

resource "aws_instance" "bastion" {
  key_name      = "${var.ssh_key_name}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"

  user_data = "${data.template_file.bastion_user_data.rendered}"

  subnet_id              = "${data.terraform_remote_state.casbah.casbah_subnet_id}"
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

  provisioner "local-exec" {
    command = "scp -i ~/.aws/moat.pem ~/.aws/casbah.pem ubuntu@${aws_instance.bastion.public_dns}:~/.ssh/casbah.pem"
  }

  # TODO: this command currently must be run manually on bastion after deployed in order to finish up the process of getting authorized_keys onto private server
  # provisioner "remote-exec" {
  #   inline = [
  #     "scp -i ~/.ssh/casbah.pem /tmp/casbah_authorized_keys ec2-user@${data.terraform_remote_state.casbah.casbah_private_ip}:~/.ssh/authorized_keys"
  #   ]
  # }

  tags {
    Name = "bastion_host"
  }
}
