# # # # # # # # # # # # # # #
# Application Load Balancer #
# # # # # # # # # # # # # # #
resource "aws_lb" "Application-Load-Balancer" {
  name               = "web-external-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  # subnets                    = [aws_subnet.Web-Public-Subnet-1.id, aws_subnet.Web-Public-Subnet-2.id]
  subnets                    = [aws_subnet.subnets[0].id, aws_subnet.subnets[1].id]
  enable_deletion_protection = false

  tags = {
    Name = "App Load Balancer"
  }
}

output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.Application-Load-Balancer.dns_name
}

# # # # # # # # # # # # # # # # # # # # # #
# Application Load Balancer Target Group  #
# # # # # # # # # # # # # # # # # # # # # #
resource "aws_lb_target_group" "alb_lb_target_group" {
  name     = "app-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.three-tier-vpc.id
}

resource "aws_lb_target_group_attachment" "web-attachment" {
  target_group_arn = aws_lb_target_group.alb_lb_target_group.arn
  # target_id        = aws_instance.Public_Web_Instance.id
  target_id        = aws_autoscaling_group.asg-1.id
  port             = 80
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.Application-Load-Balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_lb_target_group.arn
  }
}
