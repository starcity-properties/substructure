terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


#---#---#---#

data "aws_ami" "casbah_ami" {
  filter {
    name   = "name"
    values = ["casbah-repl-lein-2.8.1"]
  }
}


data "template_file" "casbah_user_data" {
  template = "${file("${path.module}/scripts/provision.sh")}"
}


resource "aws_instance" "casbah" {
  key_name               = "${var.ssh_key_name}"
  ami                    = "${data.aws_ami.casbah_ami.image_id}"
  instance_type          = "${var.instance_type}"

  user_data = "${data.template_file.casbah_user_data.rendered}"

  subnet_id = "${element(data.terraform_remote_state.vpc.public_subnet_ids, 0)}"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.casbah_inbound_id}",
    "${data.terraform_remote_state.vpc.casbah_outbound_id}"
  ]

  associate_public_ip_address = false

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/.aws/casbah.pem")}"
    agent       = false
  }

  tags {
    Name = "casbah_host"
  }
}
