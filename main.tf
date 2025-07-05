# 1. Standard Provider Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider to use your chosen region
provider "aws" {
  region = "ap-south-1" # <--- YOUR CHOSEN REGION
}

# 2. Dynamic Data Source to find the correct AMI
# This block solves the "InvalidAMIID" error by searching for the image.
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 3. Security Group Resource
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow SSH, HTTP, and K3s-required traffic"

  # SSH access from anywhere (for you to connect)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access for our web app later
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. EC2 Instance Resource
resource "aws_instance" "web_server" {
  # Use the dynamically found AMI ID
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro" # Free Tier eligible

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Use the key pair you created IN THE TARGET REGION
  key_name      = "my-aws-key"

  tags = {
    Name = "DevOps-Project-Server"
  }
}

# 5. Output for convenience
output "instance_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of the web server instance."
}