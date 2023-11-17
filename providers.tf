terraform {
    required_providers {
      aws = {
        version = "5.25.0"
        source = "hashicorp/aws"
      }
    }
}

provider "aws" {
    profile = "cloud-resume"
}