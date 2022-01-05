# @author: Syed Umair Ali
# @since: 03 Jan, 2022
# @description: Generic Terraform Lambda Module
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-lambda

module "lambda_function" {
  source                  = "terraform-aws-modules/lambda/aws"
  version                 = "2.28.0" 
  function_name           = var.function_name
  description             = var.description
  handler                 = var.handler
  runtime                 = var.runtime
  
  create_role             = false
  lambda_role             = var.lambda_role
  memory_size             = var.memory_size
  timeout                 = var.timeout
  architectures           = var.architectures

  create_package          = false
  local_existing_package  = "${path.module}/${var.local_existing_package}"

  environment_variables   = var.environment_variables

  vpc_subnet_ids          = var.vpc_subnet_ids
  vpc_security_group_ids  = var.vpc_security_group_ids
  tags = merge(
    var.common_tags,
    {
      Name          = var.function_name
    }
  )
}