# @author: Syed Umair Ali
# @since: 01 Jan, 2022
# @description: Generic Terraform RDS Aurora Module
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-rds-aurora

module "cluster" {
  source                            = "terraform-aws-modules/rds-aurora/aws"
  version                           = "6.1.3"
  name                              = var.name
  engine                            = var.engine
  engine_version                    = var.engine_version
  instance_class                    = var.instance_class
  instances                         = var.instances
  vpc_id                            = var.vpc_id
  subnets                           = var.private_subnets
  master_username                   = var.master_username
  create_random_password            = var.create_random_password
  random_password_length            = var.random_password_length
  deletion_protection               = var.deletion_protection
  publicly_accessible               = var.publicly_accessible

  backup_retention_period           = var.backup_retention_period
  preferred_backup_window           = var.preferred_backup_window
  preferred_maintenance_window      = var.preferred_maintenance_window  

  port                              = var.port
  db_subnet_group_name              = var.db_subnet_group_name
  vpc_security_group_ids            = var.vpc_security_group_ids

  apply_immediately                 = true
  create_security_group             = false
  db_parameter_group_name           = var.db_parameter_group_name
  db_cluster_parameter_group_name   = var.db_cluster_parameter_group_name

  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports   = var.enabled_cloudwatch_logs_exports

  tags = merge(
    var.common_tags,
    {
      Name          = var.name
    }
  )
}

################################################################
# Secret Manager Resource to store RDS username and passwords
################################################################
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.rds_secrets}-${terraform.workspace}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = <<EOF
{
  "rds_writer_endpoint": "${module.cluster.cluster_endpoint}",
  "rds_reader_endpoint": "${module.cluster.cluster_reader_endpoint}",
  "rds_port": "${module.cluster.cluster_port}",
  "rds_username": "${module.cluster.cluster_master_username}",
  "rds_password": "${module.cluster.cluster_master_password}",
  "rds_db": "challenge"
}
EOF
}
