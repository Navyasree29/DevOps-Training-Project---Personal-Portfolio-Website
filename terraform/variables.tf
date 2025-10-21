variable "region" {
  default = "ap-south-1"  
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default = "capstone-deploy-key"
}
