# KMS key for RDS db encryption
resource "aws_kms_key" "rds-key" {
  description = "rds-key"
  deletion_window_in_days = 10
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = "rds.amazonaws.com",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
        ],
        Resource = "*"
      },
    ]
  })
}

# Create a RDS database(Primary and Read Replica)
# db subnet group
resource "aws_db_subnet_group" "db-group" {
    name       = "db-subnet-group"
    subnet_ids = [aws_subnet.subnet-db-1a.id, aws_subnet.subnet-db-1b.id]

    tags = {
        Name = "DB subnet group"
    }
}

## export db username and password from ssm(systems-manager) parameter store ##
# username
data "aws_ssm_parameter" "username" {
  name = "/myapp/name"
}

# password
data "aws_ssm_parameter" "my_secret" {
  name = "/myapp/my_secret"  # ssm path
}

# Primary mysql db instance
resource "aws_db_instance" "primary_db" {
    allocated_storage   = 22
    storage_type        = "gp2"
    identifier          = "db-pri"
    engine              = "mysql"
    engine_version      = "8.0.33"
    instance_class      = "db.t3.micro"
    parameter_group_name = "default.mysql8.0"
    username            = data.aws_ssm_parameter.username.value # use the exported db username from ssm
    password            = data.aws_ssm_parameter.my_secret.value  # Use the exported secret value from ssm
    skip_final_snapshot  = true
    backup_retention_period  = 7       # backup retention period:7days. Note: AWS takes automatic backup of the RDS db.
    vpc_security_group_ids = [aws_security_group.rds-sg.id]
    db_subnet_group_name    = aws_db_subnet_group.db-group.name
    storage_encrypted     = true
    kms_key_id            = aws_kms_key.rds-key.id  # Use the custom KMS key
    enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery", "general"]  # enable cloudwatch logging

    tags = {
        Name = "db-pri"
    }
}

# Create the db read replica
resource "aws_db_instance" "read_replica" {
    allocated_storage   = 22
    storage_type        = "gp2"
    identifier          = "db-replica"
    engine              = "mysql"
    engine_version      = "8.0.33"
    instance_class      = "db.t3.micro"
    parameter_group_name = "default.mysql8.0"
    replicate_source_db  = aws_db_instance.primary_db.id
    username            = data.aws_ssm_parameter.username.value
    password            = data.aws_ssm_parameter.my_secret.value  # Use the exported secret value
    skip_final_snapshot  = true
    backup_retention_period  = 7
    vpc_security_group_ids = [aws_security_group.rds-sg.id]
    db_subnet_group_name    = aws_db_subnet_group.db-group.name
    storage_encrypted     = true
    kms_key_id            = aws_kms_key.rds_key.id  # Use the custom KMS key
    enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery", "general"]  # enable cloudwatch logging

    tags = {
        Name = "db-replica"
    }
}