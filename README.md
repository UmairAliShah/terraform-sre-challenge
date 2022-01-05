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



#TODO how to zip code