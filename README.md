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

After creating the ec2 key pair in `eu-west-1`, change the key pair name in
`sre-challenge-syed-ali/environments/stage.tfvars`
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
> **_NOTE:_** In case of whitelisting the static VPN IPs we have to add this rule only once

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
4. Before running the script get the `rds_endpoint, username, password` from **rds secret manager** then run the command
   > mysql -h rds_endpoint -u username -p password < create_db_table.sql

#### Note 
As we are running terraform locally so we can't make db and table on RDS as it is private can be accessed internally, But if we run the terraform on ec2 then we can use **terraform provisioner** in rds aurora module.
```bash
resource "null_resource" "db_setup" {
  provisioner "local-exec" {
    command = "psql -h ${module.cluster.cluster_endpoint} -p 3306 -U ${module.cluster.cluster_master_username}
     -p module.cluster.cluster_master_password -f path-to-file-with-sql-commands
  }
}
```

### Generate CSV and upload it on S3
Run the python script in `sre-challenge-syed-ali/helper-scripts/generate_data.py` to generate random data
in csv format.

> python3 generate_data.py

It will generate a csv file with random entries.
Now upload this file on `notify-lambda-csv-bkt-stage` s3 bucket, It would trigger lambda and lambda would 
parse the csv file and insert data in RDS.

Verify the db table and cloudwatch logs of lambda.

### Destroy the infrastructure 
If you want to destroy infrastructure

First of all empty the `notify-lambda-csv-bkt-stage` bucket then run
> terraform destroy -var-file=environments/stage.tfvars



## Lambda Code 
Lambda code to get secrets from paramter store and insert data into RDS by parsing csv file
```bash
import json
import urllib.parse
import boto3
import pymysql
import csv
import os
import urllib

secrets_client = boto3.client("secretsmanager")


# get rds secrets from secret manager
def get_value(name, stage=None):

    try:
        kwargs = {'SecretId': name}
        if stage is not None:
            kwargs['VersionStage'] = stage
        response = secrets_client.get_secret_value(**kwargs)
        rds_credentials = json.loads(response['SecretString'])
        return rds_credentials
    except Exception as e:
        print(e)


s3 = boto3.client('s3')


def lambda_handler(event, context):
    
    rds_credentials = get_value(os.environ['RDS_SECRET_MANAGER'])
    
    #Get Database Connection
    db_connection = None
    try:
        db_connection = pymysql.connect(host=rds_credentials['rds_writer_endpoint'], user=rds_credentials['rds_username'], password=rds_credentials['rds_password'], db=rds_credentials['rds_db'])
    except pymysql.MySQLError as e:
        print(e)
        print("ERROR: Unexpected error: Could not connect to MySQL instance.")
        raise e

    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'])
    
    response = s3.get_object(Bucket=bucket, Key=key)
   
    data = response['Body'].read().decode('utf-8').splitlines()

    lines = csv.reader(data)

    headers = next(lines)
    with db_connection.cursor() as cur:
        for customer in lines:
            try:
                print (str(customer))
                cur.execute('insert into customer (title, firstname, lastname, status, email, age) values("'+str(customer[0])+'", "'+str(customer[1])+'", "'+str(customer[2])+'", "'+str(customer[3])+'", "'+str(customer[4])+'", "'+str(customer[5])+'")')
                db_connection.commit()
            except Exception as e:
                print(e)
```
### ZIP the lambda code and packages
As you can see lambda code is already in zip format in 
`sre-challenge-syed-ali/modules/lambda/my-deployment-package.zip`
It is deployed during lambda provsioning using terraform

#### How to zip lamdba code and install its dependencies
```bash
mkdir lambda-source-code
cd lambda-source-code
touch lambda_function.py # Add the above code snippet in this file
pip install --target ./package pymysql
cd package
zip -r ../my-deployment-package.zip .
cd ..
zip -g my-deployment-package.zip lambda_function.py
```


# Note
* Terraform offical modules are used to provsion resources
* Code is highly scalable 
* Everything is dynamic, values are being referenced in dependant modules by exporting the 
  values in outputs such `arns, ids, names, subnets ids` etc. 

