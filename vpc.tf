# all resources required to provision a 3 tier VPC

resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  enable_dns_hostnames    = true

  tags      = {
    Name    = "vpc-${var.project}-${var.environment}"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "igw-${var.project}-${var.environment}"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public-sn-az1-${var.project}-${var.environment}"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public-sn-az2-${var.project}-${var.environment}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "public-rt-${var.project}-${var.environment}"
  }
}

resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id           = aws_subnet.public_subnet_az1.id
  route_table_id      = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id           = aws_subnet.public_subnet_az2.id
  route_table_id      = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_ecs_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_ecs_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-ecs-sn-az1-${var.project}-${var.environment}"
  }
}

resource "aws_subnet" "private_ecs_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_ecs_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-ecs-sn-az2-${var.project}-${var.environment}"
  }
}

resource "aws_subnet" "private_db_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_db_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-db-sn-az1-${var.project}-${var.environment}"
  }
}

resource "aws_subnet" "private_db_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_db_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-db-sn-az2-${var.project}-${var.environment}"
  }
}

#TODO: Network ACL to limit communication between subnets