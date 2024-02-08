resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.my_vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.my_vpc_nat_gateway.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    "Name" = "Private RT"
  }
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.my_vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.my_vpc_igw.id
      nat_gateway_id             = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    "Name" = "Public RT"
  }
}

resource "aws_route_table_association" "private_ap-south-1a" {
  subnet_id      = aws_subnet.my_vpc_pri_subnet_ap-south-1a.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private_ap-south-1b" {
  subnet_id      = aws_subnet.my_vpc_pri_subnet_ap-south-1b.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "public_ap-south-1a" {
  subnet_id      = aws_subnet.my_vpc_pub_subnet_ap-south-1a.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public_ap-south-1b" {
  subnet_id      = aws_subnet.my_vpc_pub_subnet_ap-south-1b.id
  route_table_id = aws_route_table.public_RT.id
}
