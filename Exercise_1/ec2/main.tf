resource "aws_instance" "webserver" {
   instance_type          = "${var.instance_type}"
   ami                    = "${lookup(var.aws_amis, var.aws_region)}"
   count                  = "${var.instance_count}"
   key_name               = "${var.key_name}"
   vpc_security_group_ids = ["${var.ec2_allow_ports}"]
   subnet_id              = "${element(var.ec2_public_subnets,count.index)}"
   user_data              = var.ec2_config_init 
   associate_public_ip_address = var.allow_public_ip
}