resource "aws_security_group" "sg_codebuild" {
  name = "SG-${var.app_name}-${var.env}"
  vpc_id = var.vpc_id

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.cidr_blocks]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.cidr_blocks]
  }
}