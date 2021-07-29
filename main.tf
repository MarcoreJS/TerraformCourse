terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.13.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nodered_image" {
  # name = var.image[var.env]
  name = var.image[local.env]
}

resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", local.env, random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[local.env][count.index]
  }
}


