resource "aws_vpc" "autohub_vpc" {
  cidr_block           = "10.0.0.0/23"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AUTOHUB-VPC"
  }
}

resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.autohub_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "AUTOHUB-PublicSubnet"
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id            = aws_vpc.autohub_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "AUTOHUB-PrivateSubnet"
  }
}

resource "aws_internet_gateway" "autohub_igw" {
  vpc_id = aws_vpc.autohub_vpc.id

  tags = {
    Name = "AUTOHUB-InternetGateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.autohub_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.autohub_igw.id
  }

  tags = {
    Name = "AUTOHUB-PublicRouteTable"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.autohub_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "AUTOHUB-PrivateRouteTable"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "AUTOHUB-NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_publica.id

  tags = {
    Name = "AUTOHUB-NAT-GW"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.private_route_table.id
}