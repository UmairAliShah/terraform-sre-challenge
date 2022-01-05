# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: Terraform Generic VPC Module Outputs
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-vpc 
# @module_version: 3.11.0

#################################
# VPC Outputs
#################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}
