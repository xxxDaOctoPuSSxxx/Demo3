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

variable "remoute_state_bucket" {
    type = string
}

variable "vpc_id" {
  description = "VPC id"
}

variable "cidr_blocks"{
  description = "Cidr block for codebuild security group "
  default = "0.0.0.0/0"
}

variable "buildspec_file" {
  description = "Name for buildspec file"
  default = "buildspec.yml"
}

variable "buildspec_path" {
  
}

variable "private_subnets_id" {
  description = "Private subnet ids for create codebuild in private subnets"
  type = set(string)
}

variable "pattern_branch" {
  description = "default pattern for codebuild"
  default = "^refs/heads"
}

variable "branch_githook" {
  description = "Variable for pattern that show what branch codebuild will be wait"
  default = "dev"
}

variable "git_event" {
  description = "Variable for codebuild webhook that show after what start build"
  default = "PUSH"
}

variable "repository_url" {
  type = string
  description = "GitHub repository url"

}