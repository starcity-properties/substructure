output "vagrant_private_ip" {
  value = "${aws_instance.vagrant.private_ip}"
}

output "vagrant_private_dns" {
  value = "${aws_instance.vagrant.private_dns}"
}

output "vagrant_subnet_id" {
  value = "${aws_instance.vagrant.subnet_id}"
}
