# create task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                    = var.api_service_name
  execution_role_arn        = data.tfe_outputs.infra.values.task_role_arn
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = var.api_cpu
  memory                    = var.api_memory

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
            valueFrom  = "${data.tfe_outputs.infra.values.db_ssm_host_arn}"
        },
        {
            name       = "DB_USER"
            valueFrom  = "${data.tfe_outputs.infra.values.db_ssm_host_arn}
        {
            name       = "DB_PASSWORD"
            valueFrom  = "${data.tfe_outputs.infra.values.db_ssm_host_arn}"
        },
      ]
      logConfiguration = {
        logDriver      = "awslogs",
        options        = {
          "awslogs-create-group"   = "true",
          "awslogs-group" ="/ecs/${data.tfe_outputs.infra.values.environment}/${var.api_service_name}",
          "awslogs-region"         = "${data.tfe_outputs.infra.values.region}",
          "awslogs-stream-prefix"  = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name                               = var.api_service_name
  launch_type                        = "FARGATE"
  cluster                            = data.tfe_outputs.infra.values.ecs_cluster_id
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
    subnets                 = [data.tfe_outputs.infra.values.ecs_subnet_az1_id, data.tfe_outputs.infra.values.ecs_subnet_az2_id]
    security_groups         = [data.tfe_outputs.infra.values.ecs_sg_id]
    assign_public_ip        = false
  }

  # load balancing
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = var.api_service_name
    container_port   = var.api_image_port
  }
}