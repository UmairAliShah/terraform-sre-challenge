# @author: Syed Umair Ali
# @since: 30 December, 2021
# @description: Generic Terraform Security Group Module Outputs
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-security-group

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}