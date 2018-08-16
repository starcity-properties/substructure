# vpc id & cidr

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

# subnets

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

# availability zones

output "availability_zones" {
  value = ["${var.availability_zones}"]
}

# nat eip & gateway ids

output "nat_eips" {
  value = ["${aws_eip.nat_eip.*.id}"]
}

output "nat_gw" {
  value = ["${aws_nat_gateway.nat_gw.*.id}"]
}

# route table ids

output "public_route_table_id" {
  value = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_id" {
  value = ["${aws_route_table.private.*.id}"]
}

# security group ids

output "bastion_inbound_id" {
  value = "${aws_security_group.bastion_inbound.id}"
}

output "bastion_outbound_id" {
  value = "${aws_security_group.bastion_outbound.id}"
}

output "web_inbound_id" {
  value = "${aws_security_group.web_inbound.id}"
}

output "internal_inbound_id" {
  value = "${aws_security_group.internal_inbound.id}"
}
