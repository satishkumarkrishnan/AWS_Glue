output "asg_name" {
  value = module.aws_asg.tokyo_asg.name
}

output "asg_alb_name" {
  value = module.aws_asg.test.name
}

output "asg_alb_arn" {
  value = module.aws_asg.test.arn
}

output "asg_alb_dns_name" {
  value = module.aws_asg.test.dns_name
}

output "asg_policy_arn" {
  value = module.aws_asg.tokyo_asg_policy.arn
}

output "asg_alb_hosted_zone_id" {
  value = module.aws_asg.test.zone_id
}

output "private_key" {
  value = module.aws_asg.tokyo_launch_template.key_name
}

#VPC Outputs
output "vpc_id" {
  value = module.aws_glue.vpc_id
}

output "vpc_fe_subnet" {
  value = module.aws_glue.vpc_fe_subnet
}

output "vpc_be_subnet" {
  value = module.aws_glue.vpc_be_subnet
}

output "vpc_fe_sg" {
  value = module.aws_glue.vpc_fe_sg
}

output "vpc_be_sg" {
  value = module.aws_glue.vpc_be_sg
}

output "vpc_az1" {
  value = module.aws_glue.vpc_az[0]
}

output "vpc_az2" {
  value = module.aws_glue.vpc_az[1]
}

output "vpc_subnet" {
  value = module.aws_glue.vpc_fe_subnet.id
}

#EFS output
output "efs_file_system_dns" {  
  value = module.aws_asg.tokyo_efs.dns_name
}