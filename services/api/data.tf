data "tfe_outputs" "infra" {
  organization = var.infra_organization
  workspace = var.infra_workspace
}