# Architecture
![Architecture](architecture.jpg)
> **_NOTE:_** If the image content is not clearly visble, then you can have a clear view of the image by clicking on it.

## Architecture Flow
The high level flow of this infrastruture is to populate data in RDS by processing the csv file using lambda 
whenever csv gets uploaded on S3 bucket, then the data would be used by the application running on ec2 instance.
### Steps as pointed in Digrams
1. When a csv file is uploaded on the s3 bucket.
2. It would trigger the lambda function, the lambda function would only be invoked if the file uploads with `.csv` extension.
   Permission are added on lambda to be triggered by S3 on upload events.
3. Lambda function would read RDS secrets such as `endpoint, username, password, db name` from **AWS Secret Manager**
   > Permissions to read Secrets from Secret Manager are added in Lambda Execution Role.
4. Now Lambda would create connection with RDS, get csv file from the event, open the file then process it.
5. After processing it would insert data into RDS db.
   > As RDS Auroa is `**private**` so lambda should be in `**vpc private subnets**` to access RDS, also lambda's security group should be whitelisted in RDS's Security group against port `3306`.
6. As per assumption there is an theoretical application running in ec2 instance, it has to access data from RDS.
   > EC2's security group should also be whitelisted in RDS's security group against port `3306`.
7. To access ec2 over `ssh` user's ip or vpn ip should be whitelisted in ec2's security group. As default ssh is not allowed in its ingress.


# Getting Started

## Versions
* AWS Provider version is **3.70.0**
* Terraform **0.14.7**


### Folder Structure

    sre-challenge-syed-ali
    ├── environments                # .tfvars file for all environments
    |   |── dev.tfvars                # variables initialization file for dev environment workspace
    |   └── stage.tfvars              # variables initialization file for stage environment workspace
    ├── modules                     # Terraform generic modules provided by terraform registry   
    │   ├── ec2                       
    |   |   ├── outputs.tf          
    |   |   ├── resource.tf         
    |   |   └── variables.tf
    │   ├── iam-role                  
    |   |   ├── outputs.tf          
    |   |   ├── resource.tf         
    |   |   └── variables.tf
    │   ├── lambda                  
    |   |   ├── outputs.tf          
    |   |   ├── resource.tf         
    |   |   └── variables.tf
    │   ├── rds           
    |   |   ├── outputs.tf          
    |   |   ├── resource.tf         
    |   |   └── variables.tf
    │   ├── s3               
    |   |   ├── outputs.tf          
    |   |   ├── resource.tf         
    |   |   └── variables.tf   
    │   ├── security-group        
    |   |   ├── outputs.tf          
    |   |   ├── resource.tf         
    |   |   └── variables.tf     
    │   ├── vpc                     
    |   |   ├── outputs.tf          
    |   |   ├── resource.tf         
    |   |   └── variables.tf
    ├── .gitingnore
    ├── architecture.jpg
    ├── backend.tf                  # Terraform remote state backend configuration on s3
    ├── ec2.tf                      # Theoretical application module
    ├── iam.tf                      # app ec2 and lambda execution roles modules
    ├── lambda.tf                   # Lambda module to insert data into 
    ├── outputs.tf                  # All resoruces outputs to export during provisioning 
    ├── provider.tf                 # Terraform aws provider configuration
    ├── rds.tf                      # RDS Aurora mysql module
    ├── README.md                   # README.md file of whole infrastructure
    ├── s3.tf                       # S3 module to invoke lambda on csv file upload
    ├── security_group.tf           # app ec2, rds, lambda security groups modules
    ├── tags.tf                     # Common tags for all resources
    ├── variables.tf                # All terraform modules variables declaration with default values
    └── vpc.tf                      # VPC module with mutli az public and private subnets

## Terraform setup to provision Infrastructure

We would be provisioning infra for `stage` environment

### Configure region where you want to provsion aws resources
By default `ireland (eu-west-1)` region is configured.
If you want to change the region then change the variable value in `sre-challenge-syed-ali/environments/stage.tfvars`
```bash
# default region
region   = "eu-west-1" 
```

### Configure S3 backend backet to store remote state
In `backend.tf` file
```bash
terraform {
  backend "s3" {
    bucket = "terraform-remote-state-bkt"
    key    = "terraform/terraform.tfstate"
    region = "eu-west-1"
  }
}
```
`terraform-remote-state-bkt` s3 bucket is already made in `eu-west-1` to store remote state of terraform.
If you want change it, then create new bucket and change the variables values in the above snuppet. 
Otherwise leave the configuration as it is.

### Export AWS Credentials to run terraform code
The AWS provider offers a flexible means of providing credentials for authentication. The following methods are supported, in this order, and explained below:

* Static credentials
* Environment variables
* Shared credentials/configuration file
* CodeBuild, ECS, and EKS Roles
* EC2 Instance Metadata Service

I used exporting Environment variables
so replace ***** with original credentials and export in the terminal of the root dir `sre-challenge-syed-ali`
> export AWS_ACCESS_KEY_ID="*****"

> export AWS_SECRET_ACCESS_KEY="******"

### Initialize Terraform working dir
Run the following command in the working dir `sre-challenge-syed-ali`
> terraform init

It would install
* providers
* modules
* terraform.tfstate file (s3 backend information)

### Create Workspace for multi environment infrastructure
* Workspace is used to create same resources for multiple environments
* Code reuseability for all enviroments so no code repetition

As we are deploying `stage` infra so first of all run this command to check either `stage` workspace exist or not
>  terraform workspace list              # to see stage workspace

>   terraform workspace select stage      # to select stage workspace

if workspace does not exist then create it
> terraform workspace new stage            # create new workspace

### Create EC2 key pair and white IP security group        
As app ec2 would also be launched so to access it over ssh 
* Create your own key pair
* White your IP to access over ssh (as port ssh is not allowed for everyone) 

After creating the ec2 key pair in `eu-west-1`, change the key pair name in `sre-challenge-syed-ali/environments/stage.tfvars`
```bash
raisin_app_instance_key_name        = "Key_name"
```
change the above value with the one you created.

To white list your IP, get your public ip *What is my IP* and replace in `sre-challenge-syed-ali/environments/stage.tfvars`
```bash
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
      cidr_blocks = "your_public_ip/32"
    }
  ]
```

### Deploy terraform code to provision infrastructure
validates the configuration files in a directory
> terraform validate

Execute the plan to see expected resources provisioning
> terraform plan -var-file=environments/stage.tfvars

Provision resources if everything looks fine
> terraform apply -var-file=environments/stage.tfvars


### Create DB and Table in RDS Aurora
Before populating the data into RDS by processing csv file through Lambda, DB and Table should exist.
As RDS is not publicy accessible so we have to make db and table by ssh into app ec2 instance, because its
security group is whitelisted in RDS Aurora security group.

**Steps**
1. SSH into the server
2. Run the following command to install mysql client
   > sudo apt-get install mysql-client
3. Create a file name as create_db_table.sql
```bash
CREATE DATABASE IF NOT EXISTS challenge;

USE challenge;

CREATE TABLE IF NOT EXISTS customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    status TINYINT NOT NULL default 0,
    email VARCHAR(255) NOT NULL,
    age TINYINT NOT NULL,
    import_file VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)  ENGINE=INNODB;

DESCRIBE customer;
```
4. Run the above script, before running the script get the rds_endpoint, username and password from rds secret manager
   > mysql -h rds_endpoint -u username -p password < create_db_table.sql







#TODO how to zip code