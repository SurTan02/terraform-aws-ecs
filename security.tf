resource "aws_security_group" "lb" {
    name = "load-balancer security group"
    description = "controls access to the ALB"
    vpc_id = aws_vpc.main.id

    ingress {
        protocol = "tcp"
        from_port = var.app_port
        to_port = var.app_port
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Outbound, protocol -1 == "all"
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
  }
}

# Protect EC2 instances from public traffic and set them behind Application Load Balancer.
resource "aws_security_group" "ecs_tasks" {
    name = "myapp-ecs-tasks-security-group"
    description = "allow inbound access from the ALB only"
    vpc_id = aws_vpc.main.id

  ingress {
        # protocol = "tcp"
        # from_port = var.app_port
        # to_port = var.app_port
        protocol = "-1"
        from_port = 0
        to_port = 0
        security_groups  = [aws_security_group.lb.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
  }
}