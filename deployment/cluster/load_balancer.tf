# Takes from: (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule)

resource "aws_alb" "main" {
  name            = "${var.app_name}-${var.env}-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.load_balancer.id]
}

# Listeners
resource "aws_alb_listener" "https_front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.jbot.certificate_arn
  default_action {
    target_group_arn = aws_alb_target_group.jbot.id
    type             = "forward"
  }
  
    
  
}
resource "aws_alb_listener" "http_front_end" {
  
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
        type             = "redirect"
      redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
  }
 }
}



resource "aws_alb_target_group" "jbot" {
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


