resource "aws_security_group" "alb_security_group" {
  name        = "alb-sg-${var.project}-${var.environment}"
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

