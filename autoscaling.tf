resource "aws_iam_role" "ecs_autoscale_role" {
  name = "ecs-autoscale-role"

  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "application-autoscaling.amazonaws.com"
            },
            "Effect": "Allow"
            }
        ]
    }
  EOF
}

resource "aws_iam_role_policy_attachment" "ecs-autoscale" {
  role = aws_iam_role.ecs_autoscale_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_appautoscaling_target" "ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = 10
  min_capacity       = 1
  role_arn           = aws_iam_role.ecs_autoscale_role.arn
}

resource "aws_appautoscaling_policy" "ecs_policy_count" {
  name               = "target-tracking-request-count-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
        predefined_metric_type = "ALBRequestCountPerTarget"
        resource_label = "app/${aws_alb.main.name}/${basename("${aws_alb.main.id}")}/targetgroup/${aws_alb_target_group.app.name}/${basename("${aws_alb_target_group.app.id}")}"
    }
 
    target_value       = 10
  }
}
 
# resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
#   name               = "cpu-autoscaling"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
 
#   target_tracking_scaling_policy_configuration {
#    predefined_metric_specification {
#      predefined_metric_type = "ECSServiceAverageCPUUtilization"
#    }
 
#    target_value       = 80
#   }
# } 