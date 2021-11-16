provider "aws" {
  profile = var.profile
  region = var.region
}

terraform {
 backend "s3" {
   bucket   = "devops-study-bucker"
   key      = "dev/security_group/terraform.tfstate"
   region   = "eu-central-1"
 }

}
