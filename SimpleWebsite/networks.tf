# Define the VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform_vpc"
  }
}

# Create Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "eu-north-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_3"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "website_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "website_igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.website_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Association for public_subnet_1
resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Association for public_subnet_2
resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Association for public_subnet_3
resource "aws_route_table_association" "public_rta3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id
}

