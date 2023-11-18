variable "allow_public_ip" {
  description = "Allow public ip"
  default = true
}

variable "instance_type" {
  description = "launch template EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_user_data" {
  description = "User data shell script for Apache installation"
  type        = string
  default     = <<EOF
#!/bin/bash

# Install Apache on Ubuntu

sudo apt update -y
sudo apt install -y apache2


sudo cat > /var/www/html/index.html << EOF
<html>
<head>
  <title> Apache on Ubuntu </title>
</head>
<body>
  <p> Apache was installed using Terraform!
</body>
</html>
EOF
}