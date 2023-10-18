# 3 Tier application using Terraform

## Architecture Diagram:
![image](https://github.com/gtmnagalla/3tier/assets/85630305/904cf7b8-7271-453c-b24b-2da7c173d3d2)

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

Note: By default, AWS has automatic backups enabled for RDS databases. Additionally, I use AWS Backup as an additional service.

## Initialise the terraform with following commands:
```terraform init```

```terraform plan```

```terraform apply --auto-approve```
