/*
NOTE: You cannot create EC2 key pairs using Terraform, but you can
create a key pair locally and derive a public key from it which
you can put into resource `aws_key_pair` here.

`ssh-keygen -y -f myssh.key > myssh.pub`
*/


/*====
EC2 Key Pairs
======*/

# variable "key_name" {}

# resource "tls_private_key" "example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "generated_key" {
#   key_name   = "${var.key_name}"
#   public_key = "${tls_private_key.example.public_key_openssh}"
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web" {
#   ami           = "${data.aws_ami.ubuntu.id}"
#   instance_type = "t2.micro"
#   key_name      = "${aws_key_pair.generated_key.key_name}"

#   tags {
#     Name = "HelloWorld"
#   }
# }
