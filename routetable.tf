resource "aws_route_table" "hackzurich_routing" {
  vpc_id = aws_vpc.hackzurich_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hackzurich_gateway.id
  }
  tags = {
    Name = "${var.prefix}-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.hackzurich_subnet.id
  route_table_id = aws_route_table.hackzurich_routing.id
}
