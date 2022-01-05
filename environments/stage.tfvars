# @author: Syed Umair Ali
# @since: 29 Dec, 2021
# @description: Export Outputs of all resources 
# @license: All Rights Reserved to Raisin DS


########################################
############# AWS Region ###############
########################################
region              = "eu-west-1"

########################################
###### Common Tags for resources #######
########################################
team                = "DevOps"
project             = "Terraform Code Challenge"
created_by          = "Syed Umair Ali"
organization        = "Raisin DS"

########################################
# Raisin VPC 
########################################
raisin_vpc_cidr                 = "10.0.0.0/16"
raisin_vpc_name                 = "raisin-vpc"

raisin_azs                      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
raisin_public_subnets           = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
raisin_private_subnets          = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]


raisin_enable_nat_gateway       = true
raisin_single_nat_gateway       = true
raisin_one_nat_gateway_per_az   = false 

#############################################
# Raisin app ec2 iam profile
#############################################
raisin_ec2_role                 = "raisin-app-instance-role"
raisin_ec2_profile_name         = "raisin-app-ec2"
raisin_ec2_policy_name          = "raisin-app-instance-policy"
raisin_ec2_service_identifiers  = "ec2.amazonaws.com"
raisin_ec2_policy_actions       = [ "rds:DescribeDBInstances",
                                    "rds:DescribeDBClusterEndpoints",
                                    "rds:DescribeDBClusters"]


#############################################
# Raisin app ec2 security group
#############################################
raisin_app_ec2_sg               = "raisin-app-instance-sg"
raisin_app_ec2_sg_desc          = "App Instance Security Group"
raisin_app_ec2_sg_ingress       = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http port fpor end user"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh port from specifi ip"
      cidr_blocks = "111.119.187.43/32"
    }
  ]
raisin_app_ec2_sg_egress       = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    }
  ]
#############################################
# Raisin app ec2 
#############################################
raisin_app_instance_type            = "t2.small"
raisin_app_instance_ami             = "ami-08ca3fed11864d6bb"
raisin_app_instance_key_name        = "raisinchallengekey"
associate_public_ip_address         = true
raisin_app_instance_volume_size     = "20"


#############################################
# Raisin RDS Aurora security group
#############################################
raisin_rds_aurora_sg               = "raisin-rds-aurora-sg"
raisin_rds_aurora_sg_desc          = "RDS Aurora Instance Security Group"
raisin_rds_aurora_sg_egress        = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    }
]


#############################################
# Raisin RDS Aurora Cluster
#############################################
raisin_rds_cluster_name                       = "raisin-rds"
raisin_rds_cluster_engine                     = "aurora-mysql"
raisin_rds_engine_version                     = "5.7.mysql_aurora.2.07.2"
raisin_rds_instance_class                     = "db.t3.small"
raisin_rds_instances                          = {
    one = {
      instance_class = "db.t3.small"
    }
}
raisin_rds_master_username                    = "admin"
raisin_rds_create_random_password             = true
raisin_rds_random_password_length             = 16
raisin_rds_deletion_protection                = false
raisin_rds_publicly_accessible                = false
raisin_rds_backup_retention_period            = 7
raisin_rds_preferred_backup_window            = "02:00-03:00"
raisin_rds_preferred_maintenance_window       = "sun:05:00-sun:06:00"
raisin_rds_port                               = "3306"            
raisin_rds_db_subnet_group_name               = "raisin-rds"
raisin_rds_db_parameter_group_name            = "default.aurora-mysql5.7"
raisin_rds_db_cluster_parameter_group_name    = "default.aurora-mysql5.7"
raisin_rds_copy_tags_to_snapshot              = true              
raisin_rds_enabled_cloudwatch_logs_exports    = ["error", "slowquery","audit","general"]


#################################################
# Raisin RDS Secret Manager 
#################################################
raisin_rds_secrets = "raisin-rds-smv"


#############################################
# Raisin RDS Lambda Role
#############################################
raisin_rds_lambda_role                 = "raisin-rds-lambda-role"
raisin_rds_lambda_policy_name          = "raisin-rds-lambda-role-policy"
raisin_rds_lambda_service_identifiers  = "lambda.amazonaws.com"
raisin_rds_lambda_policy_actions       = [ "logs:CreateLogGroup", 
                                            "logs:CreateLogStream",
                                            "logs:PutLogEvents",
                                            "ec2:CreateNetworkInterface",
                                            "ec2:DeleteNetworkInterface",
                                            "ec2:DescribeNetworkInterfaces",
                                            "s3:Get*",
                                            "s3:List*",
                                            "s3-object-lambda:Get*",
                                            "s3-object-lambda:List*",
                                            "secretsmanager:GetSecretValue",
                                            "secretsmanager:DescribeSecret",
                                            "secretsmanager:ListSecretVersionIds",
                                            "secretsmanager:ListSecrets" ]



#############################################
# Raisin Lambda RDS security group
#############################################
raisin_rds_lambda_sg               = "raisin-lambda-rds-aurora-sg"
raisin_rds_lambda_sg_desc          = "Lambda Security Group to acces RDS Aurora"
raisin_rds_lambda_sg_egress        = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    }
]

###############################################
# Raisin RDS Lambda Function
###############################################
rds_lambda_function_name            = "raisin-rds-lambda"
rds_lambda_description              = "Lambda function to access RDS for data insertion"
rds_lambda_handler                  = "lambda_function.lambda_handler"
rds_lambda_runtime                  = "python3.8"
rds_lambda_memory_size              = 512
rds_lambda_timeout                  = 600
rds_lambda_architectures            = [ "x86_64" ]
rds_lambda_local_existing_package   = "my-deployment-package.zip"

##################################################
# S3 Upload CSV Bucket 
##################################################
notify_rds_bucket_name            = "notify-lambda-csv-bkt"
bucket_acl_bucket_acl             = "private"
