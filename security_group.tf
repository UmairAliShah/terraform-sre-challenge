# @author: Syed Umair Ali
# @since: 30 December, 2021
# @description: Terraform Security Groups
# @license: All Rights Reserved to Raisin DS


##############################################
# App Instance Security Group to access RDS
##############################################
module "app_ec2_sg" {
  source                            = "./modules/security-group"

  name                              = "${var.raisin_app_ec2_sg}-${terraform.workspace}"
  description                       = var.raisin_app_ec2_sg_desc
  vpc_id                            = module.vpc.vpc_id

  ingress_with_cidr_blocks          = var.raisin_app_ec2_sg_ingress
  egress_with_cidr_blocks           = var.raisin_app_ec2_sg_egress
  common_tags                       = local.raisin_common_tags

}

########################################################################################
# RDS Aurora Security Group to allow access from app ec2 instance and lambda function
########################################################################################
module "rds_aurora_sg" {
  source                                    = "./modules/security-group"

  name                                      = "${var.raisin_rds_aurora_sg}-${terraform.workspace}"
  description                               = var.raisin_rds_aurora_sg_desc
  vpc_id                                    = module.vpc.vpc_id

  ingress_with_cidr_blocks                  = var.raisin_rds_aurora_sg_ingress
  ingress_with_source_security_group_id     = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "APP EC2 Security Group"
      source_security_group_id = module.app_ec2_sg.security_group_id
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "RDS Lambda Security Group"
      source_security_group_id = module.lambda_rds_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks                   = var.raisin_rds_aurora_sg_egress
  common_tags                               = local.raisin_common_tags

}

################################################
# Lambda Security Group to access RDS Aurora
################################################

module "lambda_rds_sg" {
  source                            = "./modules/security-group"

  name                              = "${var.raisin_rds_lambda_sg}-${terraform.workspace}"
  description                       = var.raisin_rds_lambda_sg_desc
  vpc_id                            = module.vpc.vpc_id

  egress_with_cidr_blocks           = var.raisin_rds_lambda_sg_egress
  common_tags                       = local.raisin_common_tags

}