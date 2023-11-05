# infra workspace variables
variable infra_organization {
  type        = string
  default     = "manraog"
  description = "Organization where infra workspace is hosted"
}

variable infra_workspace {
  type        = string
  default     = "infra"
  description = "Name of the workspace where infra was created"
}

# provider variables
variable region {
  type        = string
  default     = "us-east-1"
  description = "Region where this project is applied"
}

variable environment {
  type        = string
  default     = "development"
  description = "Environment that this applied project is associated with, it will be added as a tag to all resources"
}

variable project {
    type = string
    default = "services/api"
    description = "Name of the project to be added as a tag to all resources created"
}

# ecs service variables
variable api_image {
  type        = string
  default     = "raog/ecs-api-service:1.0.0"
  description = "Container image to be deployed"
}

variable api_service_name {
  type        = string
  default     = "api-service"
  description = "Name of the ECS service"
}

variable api_image_port {
  type        = number
  default     = 80
  description = "Port where the application listens"
}

variable api_health_path {
  type        = string
  default     = "/test"
  description = "Path to be used as health check"
}

variable api_cpu {
  type        = number
  default     = 256
  description = "CPU to be used"
}

variable api_memory {
  type        = number
  default     = 512
  description = "Memory to be used"
}

variable api_priority {
  type        = number
  default     = 1
  description = "Priority of the rule that routes traffict to this API on ALBs Listener"
}