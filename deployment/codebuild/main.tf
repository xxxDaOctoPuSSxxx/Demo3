data "aws_ssm_parameter" "git_token"{     #This  from https://www.youtube.com/watch?v=TN5E56BUn7Q&list=PLg5SS_4L6LYujWDTYb-Zbofdl44Jxb2l8&index=23
  name = "git_token"
}
resource "aws_codebuild_source_credential" "github_token" {
  auth_type = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token = data.aws_ssm_parameter.git_token.value
}

resource "aws_codebuild_project" "codebuild" {
  depends_on = [aws_codebuild_source_credential.github_token]
  name = "codebuild-${var.app_name}-${var.env}-${var.region}"
  build_timeout = "7"
  service_role = aws_iam_role.role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:4.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true

  environment_variable {
    name = var.env
    value = var.env
  }

  }



  source {
    buildspec = "${var.buildspec_path}/${var.buildspec_file}"
    type = "GITHUB"
    location = var.repository_url
    git_clone_depth = 1
    report_build_status = "true"
  }


  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.private_subnets_id
    security_group_ids = [aws_security_group.sg_codebuild.id]
  }
}

resource "aws_codebuild_webhook" "webhook" {
  project_name = aws_codebuild_project.codebuild.name

  filter_group {
    filter{
        type = "EVENT"
        pattern = var.git_event
    }

    filter {
        type = "HEAD_REF"
        pattern = "${var.pattern_branch}/${var.branch_githook}$"
    }
  }
}