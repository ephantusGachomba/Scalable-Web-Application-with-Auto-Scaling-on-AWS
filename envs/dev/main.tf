provider "aws" {
  region = "us-east-1"
}

#create vpc
resource "aws_vpc" "vpc_web" {
  cidr_block = "10.0.0.0/16"
  tags       = var.tags
}


#create public subnet A in az 1a
resource "aws_subnet" "public_subnet_A" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.vpc_web.id
  tags = {
    Name = "public_subnet_A"
  }
}

#create public subnet B in az 1b
resource "aws_subnet" "public_subnet_B" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.vpc_web.id
  tags = {
    Name = "public_subnet_B"
  }
}

#create internet gateway
resource "aws_internet_gateway" "igw_web" {
  vpc_id = aws_vpc.vpc_web.id
  tags = {
    Name = "igw_web"
  }
}

#create route table
resource "aws_route_table" "rt_web" {
  vpc_id = aws_vpc.vpc_web.id
}

#create route
resource "aws_route" "route_public_subnets" {
  route_table_id         = aws_route_table.rt_web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_web.id
}

#associate route table with public subnets A & B
resource "aws_route_table_association" "rt_ass_public" {
  count          = 2
  subnet_id      = element([aws_subnet.public_subnet_A.id, aws_subnet.public_subnet_B.id], count.index)
  route_table_id = aws_route_table.rt_web.id
}

module "ec2" {
  source        = "../../modules/ec2"
  instance_type = var.instance_type
  vpc_id        = aws_vpc.vpc_web.id
}

module "asg" {
  source             = "../../modules/asg"
  launch_template_id = module.ec2.launch_template_id
  subnet_ids         = [aws_subnet.public_subnet_A.id, aws_subnet.public_subnet_B.id]
  target_group_arn   = module.elb.frontendTG
}

module "elb" {
  source     = "../../modules/elb"
  vpc_id     = aws_vpc.vpc_web.id
  subnet_ids = [aws_subnet.public_subnet_A.id, aws_subnet.public_subnet_B.id]
}