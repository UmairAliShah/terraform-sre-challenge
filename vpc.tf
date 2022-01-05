# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: Raisin VPC
# @license: All Rights Reserved to Raisin DS

module "vpc" {
  source                    = "./modules/vpc"
  name                      = var.raisin_vpc_name
  vpc_cidr                  = var.raisin_vpc_cidr

  azs                       = var.raisin_azs
  private_subnets           = var.raisin_private_subnets
  public_subnets            = var.raisin_public_subnets
  
  enable_nat_gateway        = var.raisin_enable_nat_gateway
  single_nat_gateway        = var.raisin_single_nat_gateway
  one_nat_gateway_per_az    = var.raisin_one_nat_gateway_per_az
  
  external_nat_ip_ids       = [for nat in aws_eip.nat : nat.id]

  common_tags               = local.raisin_common_tags
}

resource "aws_eip" "nat" {
  for_each = var.raisin_single_nat_gateway ? toset([var.raisin_azs[0]]) : toset(var.raisin_azs)
  vpc      = true
  tags     = merge(local.raisin_common_tags, { "Name" : "${var.raisin_vpc_name}-${terraform.workspace}-${each.value}" })

  lifecycle {
    prevent_destroy = false
  }
}