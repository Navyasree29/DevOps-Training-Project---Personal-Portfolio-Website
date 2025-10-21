provider "aws" {
  region = var.region
}

# Create Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-06fa3f12191aa3337"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Run Docker and pull image from ECR
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin 390776111022.dkr.ecr.${var.region}.amazonaws.com
              docker pull 390776111022.dkr.ecr.${var.region}.amazonaws.com/capstone-app:latest
              docker run -d -p 80:80 390776111022.dkr.ecr.${var.region}.amazonaws.com/capstone-app:latest
              EOF

  tags = {
    Name = "CapstoneWeb"
  }
}
