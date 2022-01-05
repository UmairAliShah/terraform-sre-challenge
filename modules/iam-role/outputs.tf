# @author: Syed Umair Ali
# @since: 30 December, 2021
# @description: Generic Terraform IAM Role Outputs
# @license: All Rights Reserved to Raisin DS
# @Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

output "ec2_instance_profile" {
  description = "Instance profile"
  value       = aws_iam_instance_profile.ec2_profile.*.name
}

output "role_arn" {
  description = "Role ARN"
  value       = aws_iam_role.iam_role.arn
}