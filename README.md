# 3 Tier application using Terraform

## Architecture Diagram:
![image](https://github.com/gtmnagalla/3tier/assets/85630305/8e25b360-2cdc-4c31-a09e-b5ea70025316)


The following resources will be created:
1. VPC, subnets, route tables (multi availability zones)
2. EIP, Internet gateway, nat gateways.
3. Security groups.
4. RDS database: Primary and read replica.
5. EC2, Autoscaling Group, Launch template.
6. Application Loadbancer.
7. Web application firewall.
8. Cloudwatch logging.
9. S3 bucket for ALB logs.
10. KMS key.
11. Systems manager, parameter store.
12. AWS backup


## Installed applications:
App Server/EC2( apache, php application and cloudwatch agent)
RDS database(MySql)

## Components that are used to protect the application:
- **High Availability**: Multi AZ subnets(availability zones), Application Loadbalancer(ALB), Autoscaling group(ASG) and Secondary RDS database(read replica).
- **Identity and Access Management (IAM)**: IAM roles, EC2 iam instance profile, resource based policy.
- **Network Security**: Security Groups(ACLs) attached to ALB , App server and RDS database.
  WAF(Web application firewall): This service used to protect against the application based threats(web/database) based on aws managed rules and core rule sets.
- **Encryption**: KMS encryption configured to encrypt the RDS database using CMK. and ALB access logs using default key.
- **Data Protection**: Secondary RDS database(read replica).
  DB backup: By default, AWS has automatic backups enabled for RDS databases. Additionally, I use AWS Backup as an additional service.
  secrets management:Used SSM Parameter Store to store the database password as a secure string. (Optional: Secrets Manager)
- **Logging and Monitoring solution**: Cloudwatch logging and application monitoring by using the CW agent on app-server.
  
## Networking
- Internet gateway used to provide inbound connectivity from internet to app servers.
- Nat gateway used to provide outbound internet connectivity for app servers.
- Route tables and security groups(ACLs) to provide restricted connectivity. 

## Environment variables in the Linux environment.
To configure AWS access and secret keys as environment variables in a Linux environment and use them for Terraform provider configuration, follow these steps:

Open your shell environment configuration file. This file may vary depending on the shell you're using (e.g., Bash, Zsh, etc.). Common configuration files include ~/.bashrc or ~/.bash_profile for Bash users and ~/.zshrc for Zsh users. You can use a text editor to edit this file.

Add the following lines to set your AWS access and secret keys as environment variables. Replace YOUR_ACCESS_KEY and YOUR_SECRET_KEY with your actual AWS credentials.
```
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
```
Save and exit the configuration file.
Reload your shell environment to apply the changes.
```
source ~/.bashrc  # Replace with the actual configuration file you edited
```

## Initialise the terraform with following commands:
- ```terraform init```

- ```terraform plan```

- ```terraform apply```

- ```terraform destroy``` delete changes


### Once the installation is completed, copy the RDS endpoint name and add it to the myphpadmin configuration file on the app server as follows.
 ![image](https://github.com/gtmnagalla/3tier/assets/85630305/49639e4b-ea48-4a5c-8822-e607e7677d77)

 ![image](https://github.com/gtmnagalla/3tier/assets/85630305/6e91cf8c-774a-4fe8-9e2d-6da64890a4d7)

