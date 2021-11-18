resource "aws_ecr_repository" "ecr_repository" {
  name = local.ecr_repository_url
}