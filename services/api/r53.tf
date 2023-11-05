resource "aws_route53_record" "site_domain" {
  zone_id = data.tfe_outputs.infra.values.r53_zone_id
  name    = var.api_service_name
  type    = "A"

  alias {
    name                   = data.tfe_outputs.infra.values.alb_dns
    zone_id                = data.tfe_outputs.infra.values.alb_zone_id
    evaluate_target_health = true
  }
}