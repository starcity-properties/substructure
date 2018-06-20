terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
The VPC
======*/

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name = "vpc-starcity"
  }
}


/*====
Subnets
======*/

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "vpc-igw"
  }
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  count = "${length(var.public_ranges)}"
  vpc   = true
}


/* NAT */
resource "aws_nat_gateway" "nat_gw" {
  depends_on    = ["aws_internet_gateway.vpc"]
  count         = "${length(var.public_ranges)}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}


/* Public subnet */
resource "aws_subnet" "public" {
  count                   = "${length(var.public_ranges)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(var.public_ranges, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "public_${count.index}"
  }
}


/* Private subnet */
resource "aws_subnet" "private" {
  count             = "${length(var.private_ranges)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.private_ranges, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name = "private_${count.index}"
  }
}


/* Routes */

resource "aws_route" "public_gateway_route" {
  depends_on             = ["aws_route_table.public"]
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc.id}"
}

resource "aws_route" "private_nat_gateway_route" {
  depends_on             = ["aws_route_table.private"]
  count                  = "${length(var.private_ranges)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat_gw.*.id, count.index)}"
}


/* Routing tables */

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "public_subnet_route_table"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_ranges)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "private_subnet_route_table_${count.index}"
  }
}


/* Route table associations */

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_ranges)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_ranges)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
