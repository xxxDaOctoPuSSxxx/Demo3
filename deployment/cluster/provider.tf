provider "aws" {
  profile = var.profile
  region = var.region
}

terraform {
 backend "s3" {}
   required_providers {
     aws = {
       version = "~> 3.35"
     }
  }
}
