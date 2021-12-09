
locals {
    
    env_name = "dev-server"
    app_port = "80"
    app_name = "jbot"
    app_count = "1"
    account_id = "351279727922"
    image_tag = "1.0" # I must Fix this
    repository_name = "jbot"
    repository_url = "https://github.com/xxxDaOctoPuSSxxx/Demo3.git"
    aws_region = "eu-north-1" # I must Fix this
    aws_profile = "default"
    bucket_prefix = "jbot-s3"
    remoute_state_bucket = format("%s-%s-%s", local.app_name, local.env_name, local.aws_region)
    sub_domain_prefix = "jbot"
    domain_name = "devops-academy-kh.click"
    sub_domain = format("%s.%s", local.sub_domain_prefix, local.domain_name)
}

inputs = {
    #Global Variables
    domain_name = local.domain_name
    sub_domain_name = local.sub_domain
    profile = local.aws_profile # Use .aws credentials
    region = "eu-north-1" # Set region to deploy
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
    asg_max              = "4" # maximum running instances
    asg_desired          = "1" #count of starting fargate instances
    instance_type        = "FARGATE" # type of used fargate Instance

    # Variables for ECS
    app_count       = local.app_count
    fargate_cpu     = 256
    fargate_memory  = 512
    ecs_task_execution_role_name = "JBotEcsTaskExecutionRole"
    ecs_task_role_name = "jbot-app-task"
    image_tag = local.image_tag
    repository_name = local.repository_name
    repository_url = local.repository_url
    aws_region = local.aws_region

    #Variables for CodeBuild
    buildspec_path = "enviroments/dev-server"
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
