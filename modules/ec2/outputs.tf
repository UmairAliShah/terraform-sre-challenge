# @author: Syed Umair Ali
# @since: 31 December, 2021
# @description: Generic Terraform EC2 Module Outputs
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance

output "id" {
  description = "The ID of the instance"
  value       = module.ec2_instance.id
}

output "arn" {
  description = "The ARN of the instance"
  value       = module.ec2_instance.arn
}