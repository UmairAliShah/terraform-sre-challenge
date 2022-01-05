# @author: Syed Umair Ali
# @since: 04 Jan, 2022
# @description: Generic Terraform S3 Module variables
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket

variable "bucket_name" {
  description = <<EOF
                    The name of the bucket. If omitted, Terraform will assign a random, 
                    unique name. Must be less than or equal to 63 characters in length.
                EOF
  type        = string
}

variable "bucket_acl" {
  description = "Bucket ACL"
  type        = string
}

variable "common_tags" {
  description       = "Common tags for resources"
  type              = map(string)
}

variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "lambda_notifications" {
  description = "Map of S3 bucket notifications to Lambda function"
  type        = any
  default     = {}
}