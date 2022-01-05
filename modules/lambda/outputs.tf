# @author: Syed Umair Ali
# @since: 03 Jan, 2022
# @description: Generic Terraform Lambda Module Outputs
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-lambda

output "function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_arn
}

output "function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda_function.lambda_function_name
}