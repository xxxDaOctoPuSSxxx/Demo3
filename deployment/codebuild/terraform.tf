provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
    backend "s3" {}
    required_providers {
    aws = {
      version = "~> 3.35"
    }
  }
}