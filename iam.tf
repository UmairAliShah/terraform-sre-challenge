# @author: Syed Umair Ali
# @since: 30 December, 2021
# @description: IAM Role Modules
# @license: All Rights Reserved to Raisin DS


################################
# APP Ec2 Instance IAM Role
################################
module "ec2_iam_role" {
  source                    = "./modules/iam-role"

  name                      = "${var.raisin_ec2_role}-${terraform.workspace}"

  service_identifiers            = var.raisin_ec2_service_identifiers
  enable_instance_profile   = true
  profile_name              = "${var.raisin_ec2_profile_name}-${terraform.workspace}"
  policy_name               = "${var.raisin_ec2_policy_name}-${terraform.workspace}"
  policy_actions                = var.raisin_ec2_policy_actions
 
  common_tags               = local.raisin_common_tags
}


###################################
# Lambda RDS insertion IAM Role
###################################
module "lambda_iam_role" {
  source                    = "./modules/iam-role"

  name                      = "${var.raisin_rds_lambda_role}-${terraform.workspace}"

  service_identifiers       = var.raisin_rds_lambda_service_identifiers
  enable_instance_profile   = false
  policy_name               = "${var.raisin_rds_lambda_policy_name}-${terraform.workspace}"
  policy_actions                = var.raisin_rds_lambda_policy_actions
 
  common_tags               = local.raisin_common_tags
}
