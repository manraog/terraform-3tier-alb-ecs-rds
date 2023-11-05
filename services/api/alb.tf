# TODO: add https connection between alb and ecs
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.api_service_name}-${data.tfe_outputs.infra.values.environment}"
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

resource "aws_lb_listener_rule" "alb_host_based_route" {
  listener_arn = data.tfe_outputs.infra.values.alb_listener_arn
  priority     = var.api_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.api_service_name}.${data.tfe_outputs.infra.values.r53_base_domain}"]
    }
  }
}