resource "aws_eip" "my_vpc_elastic_ip" {
  vpc = true
  tags = {
    "Name" = "My VPC Elastic IP"
  }
}

resource "aws_nat_gateway" "my_vpc_nat_gateway" {
  allocation_id = aws_eip.my_vpc_elastic_ip.id
  subnet_id     = aws_subnet.my_vpc_pub_subnet_ap-south-1a.id
  tags = {
    "Name" = "My VPC nat gateway"
  }

  depends_on = [aws_internet_gateway.my_vpc_igw]
}