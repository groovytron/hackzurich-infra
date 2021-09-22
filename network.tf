resource "aws_vpc" "hackzurich_vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_eip" "hackzurich_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.hackzurich_gateway]
}

resource "aws_internet_gateway" "hackzurich_gateway" {
  vpc_id = aws_vpc.hackzurich_vpc.id
  tags = {
    Name = "${var.prefix}-gateway"
  }
}

resource "aws_subnet" "hackzurich_subnet" {
  vpc_id                  = aws_vpc.hackzurich_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.hackzurich_vpc.cidr_block, 3, 1)
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.hackzurich_gateway]
  tags = {
    Name = "${var.prefix}-net"
  }
}
