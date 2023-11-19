output "id" {
  description = "The ID of the instance"
  value = try(
    aws_instance.instance_t2[0].id,
    null,
  )
}

output "arn" {
  description = "The ARN of the instance"
  value = try(
    aws_instance.instance_t2[0].arn,
    null,
  )
}

output "private_ip1" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.instance_t2[0].private_ip,
    null,
  )
}

output "ami" {
  description = "AMI ID that was used to create the instance"
  value = try(
    aws_instance.instance_t2[0].ami,
    null,
  )
}

output "public_ip1" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = try(
    aws_instance.instance_t2[0].public_ip,
    null,
  )
}