
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.aws_vpc_name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "route_associate" {
  for_each       = aws_subnet.aws_subnet_block
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.id
}