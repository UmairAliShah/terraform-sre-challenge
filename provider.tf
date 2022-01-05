# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: Provider to interact with the many resources supported by AWS.
# @license: All Rights Reserved to Raisin DS
# @Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}