# @author: Syed Umair Ali
# @since: 01 Jan, 2022
# @description: Generic Terraform RDS Aurora Module Outputs
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-rds-aurora

output "cluster_endpoint" {
  description = "A writer endpoint for the cluster"
  value       = module.cluster.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.cluster.cluster_reader_endpoint
}

output "cluster_port" {
  description = "The database port"
  value       = module.cluster.cluster_port
}

output "cluster_master_password" {
  description = "The database master password"
  value       = module.cluster.cluster_master_password
  sensitive   = true
}

output "cluster_master_username" {
  description = "The database master username"
  value       = module.cluster.cluster_master_username
  sensitive   = true
}

output "rds_sm_arn" {
  description = "The database port"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}
