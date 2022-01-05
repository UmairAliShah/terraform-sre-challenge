# @author: Syed Umair Ali
# @since: 04 Jan, 2022
# @description: Generic Terraform S3 Module Outputs
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket

output "bucket_name" {
  value             = module.s3_bucket.s3_bucket_id
  description       = "Export Bucket name"
}

output "bucket_arn" {
  value             = module.s3_bucket.s3_bucket_arn
  description       = "Export Bucket ARN"
}