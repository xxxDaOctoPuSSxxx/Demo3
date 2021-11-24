terraform {
    source = "../../../deployment//codebuild"
}

include {
    path = find_in_parent_folders()
}

dependencies {
    paths = ["../cluster"]
}

dependency "cluster" {
    config_path = "../cluster"
    mock_outputs = {
        vpc_id = "vpc-000000000000"
        private_subnet_ids = ["subnet-222222222222", "subnet-333333333333"]
      
  }
}

dependency "ecr" {
    config_path = "../ecr"
    mock_outputs = {
      ecr_repository_url = "000000000000.dkr.ecr.eu-central-1.amazonaws.com/image"
  }
}

inputs = {
    vpc_id = dependency.cluster.outputs.vpc_id
    private_subnet_ids = dependency.cluster.outputs.private_subnet_ids
    ecr_repository_url = dependency.ecr.outputs.ecr_repository_url
}