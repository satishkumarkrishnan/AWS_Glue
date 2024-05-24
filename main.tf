terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.2.0"
    }
  }
}

#To use the VPC module already created
module "aws_glue" {
  source    = "git@github.com:satishkumarkrishnan/terraform-aws-vpc.git?ref=main"   
}

#To use AWS Glue config
resource "aws_glue_job" "tokyo_aws_glue" {
  name = "jsontocsv"
  role_arn = aws_iam_role.gluerole.arn

  command {
    script_location = "s3://${aws_s3_bucket.bucket.bucket}/awsgluescript.py"
    python_version = 3
  }

  provisioner "local-exec" {
    command = "aws glue start-job-run --job-name ${aws_glue_job.jsontocsv.name} --region ${var.region}"
  }
}