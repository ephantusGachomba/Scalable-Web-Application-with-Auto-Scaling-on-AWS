#1. Web Server Security Group (webserver_sg):
#Allows traffic from the Web ELB(80)
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "allow traffic from port 80 & allow all outgoing traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "webserver_sg"
  }
}

# Inbound rule for port 80 (HTTP)  traffic from the web ELB 
resource "aws_security_group_rule" "allow_tcp_web_80" {
  type              = "ingress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  description       = "Allow HTTP from Web ELB"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Inbound rule for port 22 (SSH)
resource "aws_security_group_rule" "allow_tcp_ssh_22" {
  type              = "ingress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "Allow SSH access"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Inbound rule for port 443 (HTTPS)
resource "aws_security_group_rule" "allow_tcp_https_443" {
  type              = "ingress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow HTTPS access"
  cidr_blocks       = ["0.0.0.0/0"]
}


# Allow outbound traffic to internet
resource "aws_security_group_rule" "allow_internet" {
  type              = "egress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow outbound traffic to internet"
}
