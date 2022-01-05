# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: Terraform Generic VPC Module
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-vpc 
# @module_version: 3.11.0

module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  version                 = "3.11.0"
  name                    = "${var.name}-${terraform.workspace}"
  cidr                    = var.vpc_cidr

  azs                     = var.azs
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets

  enable_nat_gateway      = var.enable_nat_gateway
  single_nat_gateway      = var.single_nat_gateway
  one_nat_gateway_per_az  = var.one_nat_gateway_per_az
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.common_tags,
    {
      Name          = "${var.name}-${terraform.workspace}"
    }
  )

  # External IP addresses for NAT gateways
  reuse_nat_ips           = true 
  external_nat_ip_ids     = var.external_nat_ip_ids
}