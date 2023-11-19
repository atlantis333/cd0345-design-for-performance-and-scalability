# TODO: Define the variable for aws_region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}

variable "function_name" {
  description = "Function name of aws lambda"
  default = "Spacelift_Test_Lambda_Function"
}