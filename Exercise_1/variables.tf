# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "prod"
}

variable "instance_type_t2" {
  description = "Value of the type for EC2 stance"
  type = string
  default = "t2.micro"
}

variable "instance_type_m4" {
  description = "Value of the type for EC2 stance"
  type = string
  default = "m4.large"
}

variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "udacity"
}

variable "price_class" {
  default     = "PriceClass_100" // Only US,Canada,Europe
  description = "CloudFront distribution price class"
}