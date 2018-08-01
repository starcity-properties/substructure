output "casbah_private_ip" {
  value = "${aws_instance.casbah.private_ip}"
}

output "casbah_private_dns" {
  value = "${aws_instance.casbah.private_dns}"
}

output "casbah_subnet_id" {
  value = "${aws_instance.casbah.subnet_id}"
}
