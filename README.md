# Architecture
![Architecture](architecture.jpg)
> **_NOTE:_** If the image content is not clearly visble, then you can have a clear view of the image by clicking on it.

## Architecture Flow
The high level flow of this infrastruture is to populate data in RDS by processing the csv using lambda 
when csv gets uploaded on S3 bucket, then the data would be used by the application running on ec2 instance.
### Steps as pointed in Digrams
1. When a csv file is uploaded on the s3 bucket.
2. It would trigger the lambda function, the lambda function would only be invoked if the file uploads with `.csv` extension.
   Permission are added on lambda to be triggered by S3 on upload events.
3. Lambda function would read RDS secrets such as `endpoint, username, password, db name` from **AWS Secret Manager**
   > Permissions to read Secrets from Secret Manager are added in Lambda Execution Role.
4. Now Lambda would create connection with RDS, get csv file from the event, open the file then process it.
5. After processing it would insert data into RDS db.
   > As RDS Auroa is `private` so lambda should be in `vpc private subnets` to access RDS, also lambda's security group should be whitelisted in RDS's Security group against port `3306`.
6. As per assumption there is an theoretical application running in ec2 instance, it has to access data from RDS.
   > EC2's security group should also be whitelisted in RDS's security group against port `3306`.
7. To access ec2 over `ssh` user's ip or vpn ip should be whitelisted in ec2's security group. As default ssh is not allowed in its ingress.






