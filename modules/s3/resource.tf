# @author: Syed Umair Ali
# @since: 04 Jan, 2022
# @description: Generic Terraform S3 Module
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket

module "s3_bucket" {
  source          = "terraform-aws-modules/s3-bucket/aws"
  version         = "2.11.1"
  bucket          = var.bucket_name
  acl             = var.bucket_acl

  tags = merge(
      var.common_tags,
      {
        Name   = var.bucket_name
      }
    )
}


##########################################
# S3 Bucket Notification on Object Upload
##########################################

resource "aws_s3_bucket_notification" "bucket_notification" {
  count             = var.create ? 1 : 0
  
  bucket            = module.s3_bucket.s3_bucket_id

  dynamic "lambda_function" {
    for_each        = var.lambda_notifications

    content {
      lambda_function_arn = lambda_function.value.function_arn
      events              = lambda_function.value.events
      filter_prefix       = lookup(lambda_function.value, "filter_prefix", null)
      filter_suffix       = lookup(lambda_function.value, "filter_suffix", null)
    }
  }
  depends_on = [
    aws_lambda_permission.allow
  ]
}

# Lambda Permissions
resource "aws_lambda_permission" "allow" {
  for_each            = var.lambda_notifications

  statement_id        = "AllowExecutionFromS3Bucket"
  action              = "lambda:InvokeFunction"
  function_name       = each.value.function_name
  principal           = "s3.amazonaws.com"
  source_arn          = module.s3_bucket.s3_bucket_arn
}