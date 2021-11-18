################################################################
            # ECR
################################################################
variable "profile" {
  type = string
}
variable "region" {
  type = string
}

variable "account_id" {
    type = string
}
variable "app_name" {
    type = string
}

variable "aws_region" {
    type = string  
}
variable "env" {
  type = string
}
variable "remoute_state_bucket" {}

locals {
    ecr_repository_url = format("%s-%s", var.app_name, var.env)
}