# TODO: Designate a cloud provider, region, and credentials
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

provider "aws" {
  profile = "devaccount"
  region  = var.aws_region
}

# Lookup Ubunut AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]  # Canonical
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}


# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "instance_t2" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_t2
  key_name      = var.key_name
#   user_data     = file("install_apache.sh")
  associate_public_ip_address = true
  subnet_id = aws_subnet.tf_test_subnet.id

#   tags = {
#     Name  = element(var.instance_tags, count.index)
#     Env = "Prod"
#   }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4

resource "aws_instance" "instance_m4" {
  count         = var.instance_count_m4
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_m4
  key_name      = var.key_name
#   user_data     = file("install_apache.sh")
  associate_public_ip_address = true
  subnet_id = aws_subnet.tf_test_subnet.id

#   tags = {
#     Name  = element(var.instance_large_tags, count.index)
#     Env = "Prod"
#   }
}

# Default VPC
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "tf_test_subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]
}

output "subnet_id" {
  value = aws_subnet.tf_test_subnet.id
}

# Default Security Group of VPC
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_vpc.default.id
  depends_on = [
    aws_vpc.default
  ]

    ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = "${var.environment}"
  }
}