resource "aws_ecs_cluster" "ecs_cluster" {
  name      = "ecs-${var.project}-${var.environment}"

  setting {
    name    = "containerInsights"
    value   = "disabled"
  }
}


# create task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                    = var.api_service_name
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = 256
  memory                    = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  # create container definition
  container_definitions     = jsonencode([
    {
      name                  = "${var.api_service_name}",
      image                 = "${var.api_image}",
      essential             = true,

      portMappings          = [
        {
          containerPort     = "${var.api_image_port}"
        }
      ],
      secrets = [
        {
            name       = "DB_HOST"
            valueFrom  = "${aws_ssm_parameter.database_connection_host.arn}"
        },
        {
            name       = "DB_USER"
            valueFrom  = "${aws_ssm_parameter.database_connection_user.arn}"
        },
        {
            name       = "DB_PASSWORD"
            valueFrom  = "${aws_ssm_parameter.database_connection_password.arn}"
        },
      ]
      logConfiguration = {
        logDriver      = "awslogs",
        options        = {
          "awslogs-create-group"   = "true",
          "awslogs-region"         = "${var.region}",
          "awslogs-stream-prefix"  = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name                               = var.api_service_name
  launch_type                        = "FARGATE"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn
  platform_version                   = "LATEST"
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  # task tagging configuration
  enable_ecs_managed_tags            = false
  propagate_tags                     = "SERVICE"

  # vpc and security groups
  network_configuration {
    subnets                 = [aws_subnet.private_ecs_subnet_az1, aws_subnet.private_ecs_subnet_az2]
    security_groups         = [aws_security_group.ecs_security_group]
    assign_public_ip        = false
  }

  # load balancing
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group
    container_name   = var.api_service_name
    container_port   = var.api_image_port
  }
}