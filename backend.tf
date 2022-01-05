# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: S3 Bucket to store terraform remote state
# @license: All Rights Reserved to Raisin DS
# @Reference: https://www.terraform.io/language/settings/backends/s3

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-bkt"
    key    = "terraform/terraform.tfstate"
    region = "eu-west-1"
  }
}