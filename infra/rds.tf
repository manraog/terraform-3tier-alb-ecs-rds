# create database subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "db-sng-${var.project}-${var.environment}"
  subnet_ids  = [aws_subnet.private_db_subnet_az1.id, aws_subnet.private_db_subnet_az2.id]
  description = "subnets for database instance"

  tags = {
    Name = "db-sng-${var.project}-${var.environment}"
  }
}

# mysql rds
resource "random_password" "password" {
  length  = 16
  special = true
}
resource "aws_db_instance" "database" {
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0.28"
  username               = var.rds_username
  password               = random_password.password.result
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = false
  skip_final_snapshot    = true
}

#TODO: IAM connection instead of user an password on ECS service

# parameter with connection string to database, this will be used by ECS service
resource "aws_ssm_parameter" "database_connection_user" {
  name        = "/${var.environment}/database/user"
  description = "Connection user to MySQL RDS instance"
  type        = "SecureString"
  value       = "${aws_db_instance.database.username}"
}

resource "aws_ssm_parameter" "database_connection_password" {
  name        = "/${var.environment}/database/password"
  description = "Connection password to MySQL RDS instance"
  type        = "SecureString"
  value       = "${random_password.password.result}"
}

resource "aws_ssm_parameter" "database_connection_host" {
  name        = "/${var.environment}/database/host"
  description = "Connection host to MySQL RDS instance"
  type        = "SecureString"
  value       = "${aws_db_instance.database.endpoint}"
}