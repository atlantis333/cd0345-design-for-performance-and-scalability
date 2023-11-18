variable "aws_region" {
  description = "Region for WC2"
}

variable "aws_amis" {
   default = {
       us-east-1 = "ami-0f9cf087c1f27d9b1"
       eu-west-2 = "ami-095ed825090131933"
   }
}

variable "instance_type" {
   description = "Type of AWS EC2 instance."
   default     = "t2.micro"
}

variable "public_key_path" {
   description = "Enter the path to the SSH Public Key to add to AWS."
   default     = "~/.ssh/demokey.pem"
}

variable "key_name" {
   description = "AWS key name"
   default     = "demokey"
}

variable "instance_count" {
   default = 1
}

variable "ec2_allow_ports" {
  description = "Ec2 allow ports"
}

variable "ec2_public_subnets" {
  description = "Ec2 public subnets"
}
variable "ec2_config_init" {
  description = "Ec2 config init"
}
variable "allow_public_ip" {
  description = "Allow public ip"
}