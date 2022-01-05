# @author: Syed Umair Ali
# @since: 04 Jan, 2022
# @description: S3 Module to notify lambda on upload event
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket

module "s3_bucket" {
  source                  = "./modules/s3"

  bucket_name             = "${var.notify_rds_bucket_name}-${terraform.workspace}"
  bucket_acl              = var.bucket_acl_bucket_acl
  lambda_notifications    = {
    rds-lambda = {
      function_arn = module.rds_lambda_function.function_arn
      events = ["s3:ObjectCreated:*"]
      filter_suffix = ".csv" 
      filter_prefix = null 
      function_name = module.rds_lambda_function.function_name
    }
  }

  
  common_tags = local.raisin_common_tags
}
