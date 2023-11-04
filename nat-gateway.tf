#TODO: Replace NAT Gateway with VPC Endpoinst
# VPC Endpoint are cheaper and only ECR is needed right now

resource "aws_eip" "eip1" {
  vpc    = true

  tags   = {
    Name = "eip1-${var.project}-${var.environment}"
  }
}

resource "aws_eip" "eip2" {
  vpc    = true

  tags   = {
    Name = "eip2-${var.project}-${var.environment}"
  }
}

resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags   = {
    Name = "ng-az1-${var.project}-${var.environment}"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags   = {
    Name = "ng-az2-${var.project}-${var.environment}"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_ecs_route_table_az1" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "private-ecs-rt-az1-${var.project}-${var.environment}"
  }
}

# associate private ecs subnet az1 with private route table az1
# db subnets don't need outbound access to internet
resource "aws_route_table_association" "private_ecs_subnet_az1_rt_az1_association" {
  subnet_id         = aws_subnet.private_ecs_subnet_az1.id
  route_table_id    = aws_route_table.private_ecs_route_table_az1.id
}

# create private route table az2 and add route through nat gateway az2
resource "aws_route_table" "private_ecs_route_table_az2" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name = "private-ecs-rt-az2-${var.project}-${var.environment}"
  }
}

# associate private app subnet az2 with private route table az2
# db subnets don't need outbound access to internet
resource "aws_route_table_association" "private_ecs_subnet_az2_rt_az2_association" {
  subnet_id         = aws_subnet.private_ecs_subnet_az2.id
  route_table_id    = aws_route_table.private_ecs_route_table_az2.id
}
