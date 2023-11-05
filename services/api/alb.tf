# TODO: add https connection between alb and ecs
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.api_service_name}-${var.environment}"
  target_type = "ip"
  port        = var.api_image_port
  protocol    = "HTTP"
  vpc_id      = data.tfe_outputs.infra.values.vpc_id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = var.api_health_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}