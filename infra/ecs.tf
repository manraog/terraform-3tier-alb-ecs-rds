resource "aws_ecs_cluster" "ecs_cluster" {
  name      = "ecs-${var.project}-${var.environment}"

  setting {
    name    = "containerInsights"
    value   = "disabled"
  }
}