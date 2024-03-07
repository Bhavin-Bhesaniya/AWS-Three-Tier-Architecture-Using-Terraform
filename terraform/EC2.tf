# # # # # # # # # # # # #
# EC2 Instance Web Tier #
# # # # # # # # # # # # #
# resource "aws_instance" "Public_Web_Instance" {
#   ami           = var.image_id
#   instance_type = var.instanance_type
#   subnet_id              = aws_subnet.subnets[0].id
#   vpc_security_group_ids = [aws_security_group.webserver_security_group.id]
#   key_name               = var.ec2_key_name
#   user_data              = base64encode(file("install-webtier.sh"))

#   tags = {
#     Name = "web-asg"
#   }
# }


# # # # # # # # # # # # #
# EC2 Instance App Tier #
# # # # # # # # # # # # #
# resource "aws_instance" "Private_App_Instance" {
#   ami           = var.image_id
#   instance_type = var.instanance_type
#   subnet_id              = aws_subnet.subnets[2].id
#   vpc_security_group_ids = [aws_security_group.ssh_security_group.id]
#   key_name               = var.ec2_key_name
#   user_data              = base64encode(file("install-apptier.sh"))

#   tags = {
#     Name = "App-asg"
#   }
# }



# # # # # # # # # # #
# ASG for Web Tier  #
# # # # # # # # # # #
resource "aws_launch_template" "web-scaling-template" {
  name_prefix   = "web-"
  image_id      = var.image_id
  instance_type = var.instanance_type
  key_name      = var.ec2_key_name
  user_data     = base64encode(file("install-webtier.sh"))

  network_interfaces {
    subnet_id       = aws_subnet.subnets[0].id
    security_groups = [aws_security_group.webserver_security_group.id]
  }
}
resource "aws_autoscaling_group" "asg-1" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  launch_template {
    id      = aws_launch_template.web-scaling-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.subnets[0].id, aws_subnet.subnets[1].id]
  target_group_arns   = [aws_lb_target_group.alb_lb_target_group.arn]

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
  
}



# # # # # # # # # # # # # # #
# ASG for Application Tier  #
# # # # # # # # # # # # # # #
resource "aws_launch_template" "app-scaling-template" {
  name_prefix   = "app-"
  image_id      = var.image_id
  instance_type = var.instanance_type
  key_name      = var.ec2_key_name
  user_data     = base64encode(file("install-apptier.sh"))

  network_interfaces {
    subnet_id       = aws_subnet.subnets[2].id
    security_groups = [aws_security_group.ssh_security_group.id]
  }
}
resource "aws_autoscaling_group" "asg-2" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  launch_template {
    id      = aws_launch_template.app-scaling-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.subnets[2].id, aws_subnet.subnets[3].id]
  target_group_arns   = [aws_lb_target_group.alb_lb_target_group.arn]

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
}
