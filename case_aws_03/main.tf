terraform { 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias = "west-2"
  region = var.aws_region_2
}
