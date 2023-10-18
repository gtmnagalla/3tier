# Create KMS key for RDS
resource "aws_kms_key" "rds_key" {
    description             = "Custom KMS key for RDS storage encryption"
    deletion_window_in_days = 7
    enable_key_rotation     = true
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Action = [
            "kms:Create*",
            "kms:Encrypt",
            "kms:Describe*",
            "kms:GenerateDataKey*",
            "kms:ReEncrypt*",
            ],
            Effect = "Allow",
            Principal = {
            Service = "rds.amazonaws.com"
            },
            Resource = "*"
        }
        ]
    })
}