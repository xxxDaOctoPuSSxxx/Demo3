variable "region" {
  type = string
}
variable "profile" {
  type = string
}
variable "app_name" {
  type = string
}

variable "env" {
    type = string
}

variable "remote_state_bucket" {
    type = string
}

variable "repo_url" {
  description = "SCM URL for fetching"
}

variable "build_spec_file" {
  default = "buildspec.yml"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "The VPC ID that CodeBuild uses"
}

variable "subnets" {
  type        = list(string)
  default     = null
  description = "The subnet IDs that include resources used by CodeBuild"
}

variable "security_groups" {
  type        = list(string)
  default     = null
  description = "The security group IDs used by CodeBuild to allow access to resources in the VPC"
}

variable "env_vars" {
  description = <<EOF
Pass env vars for codebuild project(in native for codebuild project format)
Example:
env_vars = [
      {
        "name"  = "SOME_KEY1"
        "value" = "SOME_VALUE1"
      },
      {
        "name"  = "SOME_KEY2"
        "value" = "SOME_VALUE2"
      },
    ]
EOF

  default = []
}

locals {
  codebuild_project_name = "${var.app_name}-${var.environment}"
  description = "Codebuild for ${var.app_name} environment ${var.environment}"
}

variable "branch_pattern" {
    type = string
}

variable "git_trigger_event" {
    type = string
}

variable "github_oauth_token" {
    type = string
  description = "Github OAuth token with repo access permissions"
}
