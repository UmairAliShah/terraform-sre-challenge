# @author: Syed Umair Ali
# @since: 04 Jan, 2022
# @description: Export Outputs of all resources 
# @license: All Rights Reserved to Raisin DS

# VPC 
output "rasin_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "raisn_vpc_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "raisin_vpc_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# Appllication EC2 Role

output "raisin_app_ec2_instance_profile" {
  description = "Instance profile"
  value       = module.ec2_iam_role.ec2_instance_profile
}

output "raisin_app_ec2_role_arn" {
  description = "Role ARN"
  value       = module.ec2_iam_role.role_arn
}

# Application EC2 Security Group

output "raisin_app_ec2_security_group_id" {
  description = "The ID of the ec2 security group"
  value       = module.app_ec2_sg.security_group_id
}

# RDS Aurora Security Group

output "raisin_rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = module.rds_aurora_sg.security_group_id
}

# RDS Aurora
output "raisin_rds_cluster_endpoint" {
  description = "A writer endpoint for the cluster"
  value       = module.rds_cluster.cluster_endpoint
}

output "raisin_rds_cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.rds_cluster.cluster_reader_endpoint
}

output "raisin_rds_cluster_port" {
  description = "The database port"
  value       = module.rds_cluster.cluster_port
}

output "raisin_rds_sm_arn" {
  description = "The database port"
  value       = module.rds_cluster.rds_sm_arn
}

# rds Lambda function
output "raisin_rds_lambda_role_arn" {
  description = "Role ARN"
  value       = module.lambda_iam_role.role_arn
}

output "raisin_rds_lambda_security_group_id" {
  description = "The ID of the RDS security group"
  value       = module.lambda_rds_sg.security_group_id
}

output "raisin_rds_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.rds_lambda_function.function_arn
}

output "raisin_rds_function_name" {
  description = "The name of the Lambda Function"
  value       = module.rds_lambda_function.function_name
}

# S3 upload csv bucket

output "raisin_upload_csv_bucket_name" {
  value             = module.s3_bucket.bucket_name
  description       = "Export Bucket name"
}

output "raisin_upload_csv_bucket_arn" {
  value             = module.s3_bucket.bucket_arn
  description       = "Export Bucket ARN"
}