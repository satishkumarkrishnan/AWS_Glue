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
module "vpc" {
  source    = "git@github.com:satishkumarkrishnan/terraform-aws-vpc.git?ref=main"   
}


#To use the VPC module already created
module "asg" {
  source    = "git@github.com:satishkumarkrishnan/terraform-aws-asg.git?ref=main"   
}