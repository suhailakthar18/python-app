variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
    default     = "ami-084568db4383264d4" # Ubuntu instance N.verginia
}
