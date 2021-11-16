resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 2
  max_capacity       = 4
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "${var.app_name}-${var.env}_scale_up"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  service_namespace  = "ecs"
  scalable_dimension =  "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}


# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "apache_log_group" {
  name              = "/ecs/apache"
  retention_in_days = 30

  tags = {
    Name = "cw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "apache_log_stream" {
  name           = "apache-log-stream"
  log_group_name = aws_cloudwatch_log_group.apache_log_group.name
}
