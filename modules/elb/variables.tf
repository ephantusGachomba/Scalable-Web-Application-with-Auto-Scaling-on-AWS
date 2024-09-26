variable "vpc_id" {
    description = "The ID of the VPC where the ELB will be created"
    type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the ELB"
  type        = list(string)
}
