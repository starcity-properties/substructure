output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "bastion_public_dns" {
  value = "${aws_instance.bastion.public_dns}"
}

output "bastion_subnet_id" {
  value = "${aws_instance.bastion.subnet_id}"
}
