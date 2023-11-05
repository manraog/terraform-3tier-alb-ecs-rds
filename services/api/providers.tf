# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = data.tfe_outputs.infra.values.region

  default_tags {
    tags = {
      "GeneratedBy"  = "Terraform Cloud"
      "Project"     = var.project
      "Environment" = var.values.environment
    }
  }
} 