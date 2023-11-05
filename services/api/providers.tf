# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = data.tfe_outputs.infra.values.region

  default_tags {
    tags = {
      "GeneratedBy"  = data.tfe_outputs.infra.values.generated_by
      "Project"     = data.tfe_outputs.infra.values.project
      "Environment" = data.tfe_outputs.infra.values.environment
    }
  }
} 