# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}

variable "environment" {
  description = "Deployment Environment"
  default = "prod"
}


variable "vpc_cidr" {
 type        = string
 description = "Public Subnet CIDR values"
 default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list
  description = "CIDR block for Public Subnet"
  default     = ["10.0.1.0/24"]
}

variable "private_subnets_cidr" {
  type        = list
  description = "CIDR block for Private Subnet"
  default     = ["10.0.16.0/24"]
}

variable "key_name" {
  description = "Keypair name connect to ec2"
  default = "demokey"
}

variable "instance_count" {
  description = "Count number of ec2 instance"
  default = 4
}

variable "instance_type_t2" {
  description = "Ec2 instance type t2"
  default = "t2.micro"
}
variable "instance_tags" {
  description = "Ec2 tags"
  type = list
  default = ["Udacity-1", "Udacity-2"]
}

variable "instance_count_m4" {
  description = "instance count for vm type m4.large"
  default = 2
}

variable "instance_type_m4" {
  description = "Ec2 type m4.large"
  default = "m4.large"
}

variable "instance_large_tags" {
  description = "instance tag for m4.large"
  type = list
  default = ["UdacityM4-1","UdacityM4-2"]
}