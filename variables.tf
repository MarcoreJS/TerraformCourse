variable "image" {
  type        = map(any)
  description = "image for container"
  default = {
    "default" = "nodered/node-red:latest"
    "dev"     = "nodered/node-red:latest"
    "prod"    = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map(any)

  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) > 0
    error_message = "The value is out of range."
  }
  validation {
    condition     = max(var.ext_port["prod"]...) <= 4000 && min(var.ext_port["prod"]...) >= 3000
    error_message = "The value is out of range."
  }
}

variable "int_port" {
  type    = number
  default = 1880
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

locals {
  container_count = length(var.ext_port[local.env])
  env             = terraform.workspace
}