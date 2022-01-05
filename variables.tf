# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: Variables declaration with default values for all resources
# @license: All Rights Reserved to Raisin DS


variable "region" {
  description   = "AWS region name for provider"
  default       = "us-east-1"
  type = string
}

########################################
# Common Tags for all resources
########################################
variable "team" {
  description = "The name of the team"
  default = "DevOps"
  type = string
}

variable "project" {
  description = "The name of the project"
  default = "Terraform"
  type = string
}

variable "created_by" {
  description = "Resources created by"
  default = "Syed Umair Ali"
  type = string
}

variable "organization" {
  description = "The name of the organization"
  default = "terraform"
  type = string
}

#####################################
# Raisin VPC Variables
#####################################
variable "raisin_vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "raisin_vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "raisin-vpc"
}

variable "raisin_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "raisin_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "raisin_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "raisin_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "raisin_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

variable "raisin_one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  type        = bool
  default     = false
}


#############################################
# Raisin APP Instance Profile Variables
#############################################
variable "raisin_ec2_role" {
  description = "Role name for the app instance"
  type        = string
  default     = "raisin-app-instance-role"
}

variable "raisin_ec2_profile_name" {
  description = "Profile name for the app instance ec2"
  type        = string
  default     = "raisin-app-ec2"
}

variable "raisin_ec2_policy_name" {
  description = "Policy name for the app ec2"
  type        = string
  default     = "raisin-app-instance-policy"
}

variable "raisin_ec2_service_identifiers" {
  description = "ec2 service identifiers for app instance"
  type        = string
  default     = ""
}

variable "raisin_ec2_policy_actions" {
  description = "Policy actions for app ec2"
  type        = list(string)
  default     = []
}


################################################
# Raisin APP Instance Security Group Variables
################################################
variable "raisin_app_ec2_sg" {
  description = "Name of security group"
  type        = string
  default     = null
}

variable "raisin_app_ec2_sg_desc" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "raisin_app_ec2_sg_ingress" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "raisin_app_ec2_sg_egress" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

# variable "raisin_source_sg" {
#   description = "List of ingress rules to create where 'source_security_group_id' is used"
#   type        = list(map(string))
#   default     = []
# }

################################################
# Raisin APP Instance Variables
################################################
variable "raisin_app_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "raisin_app_instance_ami" {
  type        = string
  default     = "ami-08ca3fed11864d6bb"
  description = "EC2 instance ami"
}

variable "raisin_app_instance_key_name" {
  type        = string
  description = "EC2 instance key name"
}

variable "associate_public_ip_address" {
  default     = false
  type        = bool
  description = "Assign Public IP to instance"
}

variable "raisin_app_instance_volume_size" {
  description = "ebs vol size"
  type        = string
  default     = "20"
}

#########################################################
# Raisin RDS Aurora Instance Security Group Variables
#########################################################
variable "raisin_rds_aurora_sg" {
  description = "Name of RDS aurora security group"
  type        = string
  default     = null
}

variable "raisin_rds_aurora_sg_desc" {
  description = "Description of RDS aurora security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "raisin_rds_aurora_sg_ingress" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "raisin_rds_aurora_sg_egress" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}


#########################################################
# Raisin RDS Aurora Cluster Variables
#########################################################
variable "raisin_rds_cluster_name" {
  description = "Name used across resources created"
  type        = string
  default     = ""
}

variable "raisin_rds_cluster_engine" {
  description = "The name of the database engine to be used for this DB cluster. Defaults to `aurora`. Valid Values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
  type        = string
  default     = null
}

variable "raisin_rds_engine_version" {
  description = "The database engine version. Updating this argument results in an outage"
  type        = string
  default     = null
}

variable "raisin_rds_instance_class" {
  description = "Instance type to use at master instance. Note: if `autoscaling_enabled` is `true`, this will be the same instance class used on instances created by autoscaling"
  type        = string
  default     = ""
}

variable "raisin_rds_master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "root"
}

variable "raisin_rds_create_random_password" {
  description = "Determines whether to create random password for RDS primary cluster"
  type        = bool
  default     = true
}

variable "raisin_rds_random_password_length" {
  description = "Length of random password to create. Defaults to `10`"
  type        = number
  default     = 10
}

variable "raisin_rds_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`. The default is `false`"
  type        = bool
  default     = null
}

variable "raisin_rds_publicly_accessible" {
  description = "Determines whether instances are publicly accessible. Default false"
  type        = bool
  default     = null
}

variable "raisin_rds_backup_retention_period" {
  description = "The days to retain backups for. Default `7`"
  type        = number
  default     = 7
}

variable "raisin_rds_preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the `backup_retention_period` parameter. Time in UTC"
  type        = string
  default     = "02:00-03:00"
}

variable "raisin_rds_preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in (UTC)"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "raisin_rds_port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = null
}

variable "raisin_rds_db_subnet_group_name" {
  description = "The name of the subnet group name (existing or created)"
  type        = string
  default     = ""
}

variable "raisin_rds_db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with instances"
  type        = string
  default     = null
}

variable "raisin_rds_db_cluster_parameter_group_name" {
  description = "A cluster parameter group to associate with the cluster"
  type        = string
  default     = null
}

variable "raisin_rds_copy_tags_to_snapshot" {
  description = "Copy all Cluster `tags` to snapshots"
  type        = bool
  default     = null
}

variable "raisin_rds_enabled_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: `audit`, `error`, `general`, `slowquery`, `postgresql`"
  type        = list(string)
  default     = []
}

variable "raisin_rds_instances" {
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  type        = any
  default     = {}
}

#########################################################
# Raisin RDS Secret Manger
#########################################################
variable "raisin_rds_secrets" {
  description = "raisin rds secret manager"
  type        = string
  default     = null
}


#############################################
# Raisin RDS Lambda ROle Variables
#############################################
variable "raisin_rds_lambda_role" {
  description = "Role name for the rds lambda"
  type        = string
  default     = "raisin-rds-lambda-role"
}

variable "raisin_rds_lambda_policy_name" {
  description = "Policy name for the rds lambda"
  type        = string
  default     = "raisin-rds-lambda-policy"
}

variable "raisin_rds_lambda_service_identifiers" {
  description = "lambda service identifiers for rds lambda"
  type        = string
  default     = ""
}

variable "raisin_rds_lambda_policy_actions" {
  description = "Policy actions for rds lambda role"
  type        = list(string)
  default     = []
}


################################################
# Raisin Lambda RDS Security Group Variables
################################################
variable "raisin_rds_lambda_sg" {
  description = "Name of lambda rds security group"
  type        = string
  default     = null
}

variable "raisin_rds_lambda_sg_desc" {
  description = "Description of lambda rds security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "raisin_rds_lambda_sg_egress" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

#################################################
# RDS Lambda Variables
#################################################
variable "rds_lambda_function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = ""
}

variable "rds_lambda_description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
  default     = ""
}

variable "rds_lambda_handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
}

variable "rds_lambda_runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = ""
}

variable "rds_lambda_memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}

variable "rds_lambda_timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "rds_lambda_architectures" {
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]."
  type        = list(string)
  default     = null
}

variable "rds_lambda_local_existing_package" {
  description = "The absolute path to an existing zip-file to use"
  type        = string
  default     = null
}

####################################
# S3 upload csv bucket Variable
####################################

variable "notify_rds_bucket_name" {
  description = <<EOF
                    The name of the bucket. If omitted, Terraform will assign a random, 
                    unique name. Must be less than or equal to 63 characters in length.
                EOF
  type        = string
}

variable "bucket_acl_bucket_acl" {
  description = "Bucket ACL"
  type        = string
}