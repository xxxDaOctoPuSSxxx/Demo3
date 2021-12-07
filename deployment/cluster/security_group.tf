

resource "aws_security_group" "load_balancer" {
  name        = "${var.app_name}-${var.env}-load-balancer-sg"
  description = "controls access to the Appication Load Balancer"
  vpc_id      = aws_vpc.demo_vpc.id
  tags = {
    Name = "Security Group for controll access to the Load Balancer${var.app_name} ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-${var.env}-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.demo_vpc.id
  tags = {
    Name = "Security Group for allow inbound access ${var.app_name} ${var.env}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
