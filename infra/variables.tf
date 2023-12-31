# variables to setup this project

# provider variables
variable region {
  type        = string
  default     = "us-east-1"
  description = "Region where this project is applied"
}

variable environment {
  type        = string
  default     = "development"
  description = "Environment that this applied project is associated with, it will be added as a tag to all resources"
}

variable project {
    type = string
    default = "infra"
    description = "Name of the project to be added as a tag to all resources created"
}

# vpc variables
variable vpc_cidr {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable public_subnet_az1_cidr {
  type        = string
  default     = "10.0.0.0/24"
  description = "CIDR for Public Subnet on AZ1"
}

variable public_subnet_az2_cidr {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR for Public Subnet on AZ2"
}

variable private_ecs_subnet_az1_cidr {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR for ECS Private Subnet on AZ1"
}

variable private_ecs_subnet_az2_cidr {
  type        = string
  default     = "10.0.3.0/24"
  description = "CIDR for ECS Private Subnet on AZ2"
}

variable private_db_subnet_az1_cidr {
  type        = string
  default     = "10.0.4.0/24"
  description = "CIDR for DB Private Subnet on AZ1"
}

variable private_db_subnet_az2_cidr {
  type        = string
  default     = "10.0.5.0/24"
  description = "CIDR for DB Private Subnet on AZ2"
}

# rds variables
variable rds_username {
  type        = string
  default     = "admin"
  description = "Admin user for MySQL"
}

# route53 and cerificate manager variables
variable r53_domain {
  type        = string
  default     = "timelineage.site"
  description = "Base domain for applications"
}

variable r53_domain_alternative_name {
  type        = string
  default     = "*.timelineage.site"
  description = "Alternative domain for applications"
}

