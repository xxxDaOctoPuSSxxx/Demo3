resource "aws_alb" "main" {
  name            = "${var.app_name}-${var.env}-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.load_balancer.id]
}

resource "aws_alb_target_group" "apache" {
  name        = "${var.app_name}-${var.env}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.demo_vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

