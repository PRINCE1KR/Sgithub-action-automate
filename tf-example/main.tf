data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

provider "aws" {
  region = "us-east-2"
}

# Add a variable to control EC2 instance creation
variable "create_instance" {
  description = "Whether to create an EC2 instance"
  type        = bool
  default     = true
}

# Create the EC2 instance conditionally based on the value of create_instance variable
resource "aws_instance" "app_server" {
  count         = var.create_instance ? 1 : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "app-ssh-key"

  tags = {
    Name = var.ec2_name
  }
}

# Add a variable to control S3 bucket creation
variable "create_s3_bucket" {
  description = "Whether to create an S3 bucket"
  type        = bool
  default     = true
}

# Create the S3 bucket conditionally based on the value of create_s3_bucket variable
resource "aws_s3_bucket" "my_bucket" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = "my-s3-bk8t"
  acl    = "private"
}

# Output the EC2 instance's public IP address and the S3 bucket name
output "instance_ip_address" {
  value       = var.create_instance ? aws_instance.app_server[0].public_ip : null
  description = "Public IP address of the EC2 instance (if created)"
}

output "s3_bucket_name" {
  value       = var.create_s3_bucket ? aws_s3_bucket.my_bucket[0].id : null
  description = "Name of the S3 bucket (if created)"
}
