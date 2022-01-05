# @author: Syed Umair Ali
# @since: 03 Jan, 2022
# @description: Generic Terraform Lambda Module
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-lambda

module "rds_lambda_function" {
  source                    = "./modules/lambda"

  function_name             = "${var.rds_lambda_function_name}-${terraform.workspace}"
  description               = var.rds_lambda_description
  handler                   = var.rds_lambda_handler
  runtime                   = var.rds_lambda_runtime
  lambda_role               = module.lambda_iam_role.role_arn
  memory_size               = var.rds_lambda_memory_size
  timeout                   = var.rds_lambda_timeout
  architectures             = var.rds_lambda_architectures

  local_existing_package    = var.rds_lambda_local_existing_package

  environment_variables     = {
    RDS_SECRET_MANAGER = "${var.raisin_rds_secrets}-${terraform.workspace}"
  }

  vpc_subnet_ids            = module.vpc.private_subnets
  vpc_security_group_ids    = [module.lambda_rds_sg.security_group_id]

  common_tags               = local.raisin_common_tags
}