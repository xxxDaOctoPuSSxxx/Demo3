#################################################################
            #Take variables from Terragrunt inputs
#################################################################
variable "profile"{}
variable "region"{}
variable "env" {}
variable "owner" {}
variable "project" {}
variable "app_name" {}

################################################################
            # Variables from Terragrunt for currient module
################################################################
variable "vpc_cidr" {}
variable "az_count" {}

################################################################
            # Variables for security_group
################################################################
variable "app_port" {}        

################################################################
            # Load balancer variables
################################################################
variable "health_check_path" {
  default = "/"
}

################################################################
            # Auto Scaling group
################################################################
variable "asg_min" {}
variable "asg_max" {}
variable "asg_desired" {}
################################################################
            # ECS
################################################################
variable "fargate_cpu" {}
variable "fargate_memory" {}
variable "app_count" {}
variable "ecs_task_execution_role_name" {}
variable "ecs_task_role_name" {}
variable "ecr_repository_url" {
  type = string
}
variable "image_tag" {
  type = string
}
locals{
  app_image = format("%s:%s", var.ecr_repository_url, var.image_tag)
}
variable "taskdef_template" {
   default = "apache_app.json.tpl"
}
variable "aws_region" {
  description = "aws region"
}

################################################################

variable "domain_name"{
  
}
variable "sub_domain_name"{
  
}