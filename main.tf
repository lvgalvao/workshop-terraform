terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///Users/lucianogalvao/.docker/run/docker.sock"
}
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "docker_image" "streamlit" {
  name         = "mystreamlitapp:latest"
  build {
    context = "."
  }
  keep_locally = false
}

resource "docker_container" "streamlit" {
  image = docker_image.streamlit.image_id
  name  = "streamlit_app_${random_string.suffix.result}"
  ports {
    internal = 8501
    external = 8501
  }
}

output "container_id" {
  value = docker_container.streamlit.id
}

output "container_name" {
  value = docker_container.streamlit.name
}