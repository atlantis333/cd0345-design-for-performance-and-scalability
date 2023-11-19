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
  profile = "devaccount"
  region  = var.aws_region
}

resource "aws_iam_role" "lambda_role" {
name   = "Spacelift_Test_Lambda_Function_Role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "aws_iam_policy_for_terraform_aws_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role        = aws_iam_role.lambda_role.name
    policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
   name = "/aws/lambda/${var.function_name}"
   retention_in_days = 7
   lifecycle {
     prevent_destroy = false
   }
}

data "archive_file" "zip_the_python_code" {
    type        = "zip"
    source_dir  = "${path.module}/python/"
    output_path = "${path.module}/python/lambda.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
    filename                       = "${path.module}/python/lambda.zip"
    function_name                  = var.function_name
    role                           = aws_iam_role.lambda_role.arn
    handler                        = "index.lambda_handler"
    # layers                         = [aws_lambda_layer_version.lambda_layer.arn]
    runtime                        = "python3.9"
    source_code_hash               = data.archive_file.zip_the_python_code.output_base64sha256
    depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

resource "aws_cloudwatch_dashboard" "demo-dashboard" {
  dashboard_name = "demo-dashboard-${data.aws_ami.ubuntu.id}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${data.aws_ami.ubuntu.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${data.aws_ami.ubuntu.id} - CPU Utilization"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 7
        width  = 3
        height = 3

        properties = {
          markdown = "My Demo Dashboard"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              "${data.aws_ami.ubuntu.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${data.aws_ami.ubuntu.id} - NetworkIn"
        }
      }
    ]
  })
}