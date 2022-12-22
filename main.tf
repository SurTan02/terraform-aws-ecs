resource "aws_ecs_cluster" "main" {
  name = "nginx-tf-fargate-13520059-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "nginx-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu #1024
  memory                   = var.fargate_memory #2048
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "nginx",
      "image"     : "nginx:latest",
      "cpu"       : 1024,
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "main" {
  name                 = "nginx-service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.app.arn
  desired_count        = var.app_count
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.lb.id,
      aws_security_group.ecs_tasks.id
    ]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "nginx"
    container_port   = var.app_port
  }

  depends_on = [
    aws_lb_listener.ecs_alb_listener
  ]
}