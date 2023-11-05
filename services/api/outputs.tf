output service_url {
  value       = "https://${var.api_service_name}.${data.tfe_outputs.infra.values.r53_base_domain}"
  sensitive   = false
  description = "URL to consume the service"
}
