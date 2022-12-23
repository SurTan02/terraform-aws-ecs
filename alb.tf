resource "aws_alb" "main"{
    name = "load balancer"
    subnets = aws_subnet.public.*.id
    security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
    port        = var.app_port
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = aws_vpc.main.id

    health_check {
        matcher = "200"
        path    = var.health_check_path
        
        interval = 20
        timeout = 10
        healthy_threshold = 2
        unhealthy_threshold = 3
    }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}