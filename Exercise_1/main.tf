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
  profile = "adminacc"
  region  = var.aws_region
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
# resource "aws_instance" "ec2T2" {
#   ami           = "ami-05c13eab67c5d8861" # Amazon Linux
#   instance_type = var.instance_type_t2
# }

# TODO: provision 2 m4.large EC2 instances named Udacity M4
# resource "aws_instance" "ec2m4" {
#   ami           = "ami-05c13eab67c5d8861" # Amazon Linux
#   instance_type = var.instance_type_m4
# }