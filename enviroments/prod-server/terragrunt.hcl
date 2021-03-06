/*terraform {
    source = "../..//deployment" # Terragrunt need (//) to run Terraform correctly
}*/

locals {
    
    env_name = "prod-server"
    app_port = "80"
    app_name = "apache-html"
    app_count = "2"
    account_id = "351279727922"
    image_tag = "1.0" # I must Fix this
    repository_name = "apache-app"
    aws_region = "us-east-1" # I must Fix this
    aws_profile = "default"
    bucket_prefix = "demo3-prod"
    remoute_state_bucket = format("%s-%s-%s", local.app_name, local.env_name, local.aws_region)
}

inputs = {
    #Global Variables
    profile = local.aws_profile # Use .aws credentials
    region = local.aws_region # Set region to deploy
    env = local.env_name # Set neme of enviroment variables added to tags
    owner = "Roman Hryshchenko" # Set owner name in tags
    project = "Soft_Serve_DevOps_Study" # Set project name in tags
    app_name = local.app_name  # Set Application name in tags

    # Set variables to Network module
    vpc_cidr = "10.0.0.0/16" # Set CIDR_BLOCK to created VPC
    az_count = "2" # Set count of availability zones to deploy in seted region

    # Variable to Security Group module
    app_port     = local.app_port

   # # Variable for ECR module
    account_id = local.account_id
    remoute_state_bucket = local.remoute_state_bucket

    # Variables for Auto scaling group
    asg_min              = "1" # minimum running instances
    asg_max              = "2" # maximum running instances
    asg_desired          = "1" #count of starting fargate instances
    instance_type        = "FARGATE" # type of used fargate Instance

    # Variables for ECS
    app_count       = local.app_count
    fargate_cpu     = 256
    fargate_memory  = 512
    ecs_task_execution_role_name = "ApacheEcsTaskExecutionRole"
    ecs_task_role_name = "apache-app-task"
    image_tag = local.image_tag
    repository_name = local.repository_name
    aws_region = local.aws_region
}

remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = format("%s-%s-%s-%s", local.bucket_prefix, local.app_name, local.env_name, local.aws_region)
    key            = format("%s/terraform.tfstate", path_relative_to_include())
    region         = local.aws_region
    dynamodb_table = format("tflock-%s-%s-%s", local.env_name, local.app_name, local.aws_region)
    profile        = local.aws_profile
  }
}