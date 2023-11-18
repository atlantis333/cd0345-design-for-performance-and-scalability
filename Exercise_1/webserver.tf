resource "aws_security_group" "alb_security_group" {
   name        = "allow_ssh_http"
   description = "Allow inbound SSH traffic and http from any IP"
   vpc_id      = "${module.vpc.vpc_id}"

   #ssh access
#    ingress {
#        from_port   = 22
#        to_port     = 22
#        protocol    = "tcp"
#        # Restrict ingress to necessary IPs/ports.
#        cidr_blocks = ["0.0.0.0/0"]
#    }

   # HTTP access
   ingress {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       # Restrict ingress to necessary IPs/ports.
       cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_security_group" "asg_security_group" {
  name        = "${var.environment}-asg-security-group"
  description = "ASG Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# module "ec2" {
#   source = "./ec2"
#   aws_region = var.aws_region
#   ec2_allow_ports = aws_security_group.allow_ports.id
#   ec2_public_subnets = module.vpc.public_subnets
#   ec2_config_init = "${file("scripts/init.sh")}"
#   allow_public_ip = var.allow_public_ip
# }

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

## Launch Template and ASG Resources

resource "aws_launch_template" "launch_template" {
  name          = "${var.environment}-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg_security_group.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-asg-ec2"
    }

  }
  user_data = base64encode("${var.ec2_user_data}")
}

resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = module.vpc.public_subnets[*]
  target_group_arns   = [aws_lb_target_group.target_group.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
}

# Application Load Balancer Resources

resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = module.vpc.private_subnets[*]
  idle_timeout       = 60
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.environment}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}