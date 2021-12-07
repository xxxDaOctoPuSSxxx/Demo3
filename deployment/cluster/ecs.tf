resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.env}-cluster"
}

data "template_file" "jbot" {
  template = file("../templates/image/image.json")
  vars = {
    app_image      = local.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    env            = var.env
    app_name       = var.app_name
    image_tag      = var.image_tag
  }
}
resource "aws_ecs_task_definition" "jbot-def" {
  family = "jbot"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = data.template_file.jbot.rendered
}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-${var.env}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.jbot-def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.jbot.id
    container_name   = "jbot"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.https_front_end, aws_iam_role.ecs_task_execution_role]
}