# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = var.region

  default_tags {
    tags = {
      "GeneratedBy"  = var.generated_by
      "Project"     = var.project
      "Environment" = var.environment
    }
  }
} 