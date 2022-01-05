# @author: Syed Umair Ali
# @since: 30 December, 2021
# @description: Generic Terraform Security Group Module
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-security-group

module "security_group" {
  source                                = "terraform-aws-modules/security-group/aws"
  version                               = "4.7.0"
  name                                  = var.name
  description                           = var.description
  vpc_id                                = var.vpc_id

  ingress_with_cidr_blocks              = var.ingress_with_cidr_blocks
  ingress_with_source_security_group_id = var.ingress_with_source_security_group_id
  egress_with_cidr_blocks               = var.egress_with_cidr_blocks
  tags = merge(
    var.common_tags,
    {
      Name          = var.name
    }
  )
}