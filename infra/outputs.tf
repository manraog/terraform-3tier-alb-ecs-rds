output region {
  value       = var.region
  sensitive   = false
  description = "Region where this project is applied"
}

output environment {
  value       = var.environment
  sensitive   = false
  description = "Environment that this applied project is associated with, it will be added as a tag to all resources"
}

output project {
  value       = var.project
  sensitive   = false
  description = "Name of the project to be added as a tag to all resources created"
}

output project {
  value       = var.generated_by
  sensitive   = false
  description = "String to be added as a tag to all resources created by this project"
}

output vpc_id {
  value       = aws_vpc.vpc.id
  sensitive   = false
  description = "VPC ID"
}

output task_role_arn {
  value       = aws_iam_role.ecs_task_execution_role.arn
  sensitive   = false
  description = "ECS Task Execution Role ARN"
}

output db_ssm_host_arn {
  value       = aws_ssm_parameter.database_connection_host.arn
  sensitive   = false
  description = "ARN from parameter wich contains DB host"
}

output db_ssm_user_arn {
  value       = aws_ssm_parameter.database_connection_user.arn
  sensitive   = false
  description = "ARN from parameter wich contains DB user"
}

output db_ssm_password_arn {
  value       = aws_ssm_parameter.database_connection_password.arn
  sensitive   = false
  description = "ARN from parameter wich contains DB password"
}

output ecs_cluster_id {
  value       = aws_ecs_cluster.ecs_cluster.id
  sensitive   = false
  description = "ECS Cluster ID"
}

output ecs_subnet_az1_id {
  value       = aws_subnet.private_ecs_subnet_az1.id
  sensitive   = false
  description = "ECS Cluster Private subnet AZ1"
}

output ecs_subnet_az2_id {
  value       = aws_subnet.private_ecs_subnet_az2.id
  sensitive   = false
  description = "ECS Cluster Private subnet AZ2"
}

output ecs_sg_id {
  value       = aws_security_group.ecs_security_group.id
  sensitive   = false
  description = "ECS Cluster ID"
}
