resource "aws_autoscaling_group" "frontendASG" {
  name     = "frontendASG"
  min_size = 2
  max_size = 6

  health_check_type = "EC2"

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [var.target_group_arn]

  #specify the launch template that contains the configuration for the EC2 instances you want to create
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = var.launch_template_id
      }

    }
  }
  tag {
    key                 = "Name"
    value               = "FrontendInstance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asgpolicy" {
  name                   = "asgpolicy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.frontendASG.name

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 25.0
  }
}