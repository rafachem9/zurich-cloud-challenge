provider "aws" {

  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true


  endpoints {
    s3             = "http://s3.172.21.0.2.localstack.cloud:4566"
    lambda         = "http://172.21.0.2:4566"
    dynamodb        = "http://172.21.0.2:4566"
    ec2            = "http://172.21.0.2:4566"
  }
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Update with your desired VPC CIDR block
}

# Create a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"  # Update with your desired subnet CIDR block
}

# Create a security group for the instances
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow inbound SSH and necessary ports"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3035
    to_port     = 3035
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3035
    to_port     = 3035
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the first EC2 instance
resource "aws_instance" "instance1" {
  ami           = "ami-0c94855ba95c71c99"  # Update with your desired AMI ID
  instance_type = "t2.micro"  # Update with your desired instance type

  subnet_id         = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  key_name = "instance1-key"  # Update with your desired key pair name

  tags = {
    Name = "instance1"
  }
}

# Create the second EC2 instance
resource "aws_instance" "instance2" {
  ami           = "ami-0c94855ba95c71c99"  # Update with your desired AMI ID
  instance_type = "t2.micro"  # Update with your desired instance type

  subnet_id         = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  key_name = "instance2-key"  # Update with your desired key pair name

  tags = {
    Name = "instance2"
  }
}
