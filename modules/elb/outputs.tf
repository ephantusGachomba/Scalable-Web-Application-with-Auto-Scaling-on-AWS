output "elb_dns_name" {
  description = "The DNS name of the frontend load balancer"
  value       = aws_lb.frontend_lb.dns_name
}

output "frontendTG" {
  value = aws_lb_target_group.frontendTG.arn 
}
