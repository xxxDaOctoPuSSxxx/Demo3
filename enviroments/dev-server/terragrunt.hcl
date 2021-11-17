include {
    path= find_in_parent_folders()
}

terraform {
    source = "../../modules//deployment" # Terragrunt need (//) to run Terraform correctly
}

locals {
    env_name = replace(path_relative_to_include(), "enviroments/", "")
    app_port = "80"
    app_name = "apache-html"
    app_count = "2"
    ecr_repository_url = "351279727922.dkr.ecr.eu-central-1.amazonaws.com/apache-app"# I must Fix this
    image_tag = "1.0" # I must Fix this
    repository_name = "apache-app"
    aws_region = "eu-central-1" # I must Fix this
}

inputs = {
    #Global Variables
    profile = "default" # Use .aws credentials
    region = "eu-central-1" # Set region to deploy
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
   #  repository_name = format("%s-%s", local.app_name, local.env_name)


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
    ecr_repository_url = local.ecr_repository_url
    image_tag = local.image_tag
    repository_name = local.repository_name
    aws_region = local.aws_region
}
