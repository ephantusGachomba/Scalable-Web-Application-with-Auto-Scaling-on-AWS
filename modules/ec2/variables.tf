variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  default     = "t2.micro"
}


variable "vpc_id" {
    description = "The ID of the VPC where the ELB will be created"
    type        = string
}