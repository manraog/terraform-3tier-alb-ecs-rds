resource "aws_security_group" "alb_security_group" {
  name        = "sg-alb-${var.project}-${var.environment}"
  description = "enable https access on port 443"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "alb-sg-${var.project}-${var.environment}"
  }
}

## TODO: Add TLS comunication between ALB and ECS
resource "aws_security_group" "ecs_security_group" {
  name        = "sg-ecs-${var.project}-${var.environment}"
  description = "enable http access on port 80 via alb sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "sg-ecs-${var.project}-${var.environment}"
  }
}

resource "aws_security_group" "database_security_group" {
  name        = "sg-db-${var.project}-${var.environment}"
  description = "enable mysql access on port 3306"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "mysql access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.ecs_security_group.id]
  }

   # SG are stateful so is not needed an egress rule

  tags   = {
    Name = "sg-db-${var.project}-${var.environment}"
  }
}

#TODO: Add a bastion host