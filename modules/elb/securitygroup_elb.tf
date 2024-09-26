#. ELB Security Group for Web (web_elb_sg):
#Allows incoming traffic from the Internet
#Allows outbound traffic to the Web Servers.
resource "aws_security_group" "web_elb_sg" {
  name        = "web_elb_sg"
  description = "Allow traffic from the internet & allow all outgoing traffic to webservers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "web_elb_sg"
  }
}

# allow Inbound rule traffic from internet
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_webelb_80" {
  security_group_id = aws_security_group.web_elb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}


# Allow outbound traffic to web servers 
resource "aws_security_group_rule" "allow_outbound_webelb_web_80" {
  type              = "egress"
  security_group_id = aws_security_group.web_elb_sg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/24"]
}
