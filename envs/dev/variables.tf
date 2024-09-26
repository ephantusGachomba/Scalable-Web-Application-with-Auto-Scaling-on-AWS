variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}



variable "tags" {
  description = "Tags for the day26terraform project"
  type        = map(string)
  default = {
    Name        = "day26terraform"
    Environment = "Development"
    Project     = "TerraformProject"
  }
}
