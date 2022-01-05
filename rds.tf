# @author: Syed Umair Ali
# @since: 01 Jan, 2022
# @description: RDS Aurora Module 
# @license: All Rights Reserved to Raisin DS

module "rds_cluster" {
  source                            = "./modules/rds"

  name                              = "${var.raisin_rds_cluster_name}-${terraform.workspace}"
  engine                            = var.raisin_rds_cluster_engine
  engine_version                    = var.raisin_rds_engine_version
  instance_class                    = var.raisin_rds_instance_class
  instances                         = var.raisin_rds_instances 
  vpc_id                            = module.vpc.vpc_id
  private_subnets                   = module.vpc.private_subnets

  master_username                   = var.raisin_rds_master_username
  create_random_password            = var.raisin_rds_create_random_password
  random_password_length            = var.raisin_rds_random_password_length
  deletion_protection               = var.raisin_rds_deletion_protection
  publicly_accessible               = var.raisin_rds_publicly_accessible

  backup_retention_period           = var.raisin_rds_backup_retention_period
  preferred_backup_window           = var.raisin_rds_preferred_backup_window
  preferred_maintenance_window      = var.raisin_rds_preferred_maintenance_window  

  port                              = var.raisin_rds_port
  db_subnet_group_name              = "${var.raisin_rds_db_subnet_group_name}-${terraform.workspace}"
  vpc_security_group_ids            = [module.rds_aurora_sg.security_group_id]

  db_parameter_group_name           = var.raisin_rds_db_parameter_group_name
  db_cluster_parameter_group_name   = var.raisin_rds_db_cluster_parameter_group_name
 

  copy_tags_to_snapshot             = var.raisin_rds_copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports   = var.raisin_rds_enabled_cloudwatch_logs_exports

  rds_secrets                       = var.raisin_rds_secrets
  common_tags                       = local.raisin_common_tags
}

