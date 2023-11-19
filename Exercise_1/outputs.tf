output "id" {
  description = "The ID of the instance"
  value = try(
    aws_instance.instance_t2[0].id,
    aws_instance.instance_m4[0].id,
    null,
  )
}

output "arn" {
  description = "The ARN of the instance"
  value = try(
    aws_instance.instance_t2[0].arn,
    aws_instance.instance_m4[0].arn,
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
output "private_ip2" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.instance_t2[1].private_ip,
    null,
  )
}

output "private_ip3" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.instance_t2[2].private_ip,
    null,
  )
}

output "private_ip4" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.instance_t2[3].private_ip,
    null,
  )
}

output "private_ip5" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.instance_m4[0].private_ip,
    null,
  )
}

output "private_ip6" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.instance_m4[1].private_ip,
    null,
  )
}


output "ami" {
  description = "AMI ID that was used to create the instance"
  value = try(
    aws_instance.instance_t2[0].ami,
    aws_instance.instance_m4[0].ami,
    aws_instance.instance_t2[1].ami,
    aws_instance.instance_m4[1].ami,
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

output "public_ip2" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = try(
    aws_instance.instance_t2[1].public_ip,
    null,
  )
}

output "public_ip3" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = try(
    aws_instance.instance_t2[2].public_ip,
    null,
  )
}

output "public_ip4" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = try(
    aws_instance.instance_t2[3].public_ip,
    null,
  )
}

output "public_ip5" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = try(
    aws_instance.instance_m4[0].public_ip,
    null,
  )
}

output "public_ip6" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value = try(
    aws_instance.instance_m4[1].public_ip,
    null,
  )
}