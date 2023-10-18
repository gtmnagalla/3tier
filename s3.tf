# Create an S3 bucket for storing logs of all components
resource "aws_s3_bucket" "mybucket" {
    bucket = "3tier-bucket-logs" 
}

# enable server side encryption. default: aws/s3
resource "aws_s3_bucket_server_side_encryption_configuration" "encry-bucket" {
    bucket = aws_s3_bucket.mybucket.id

    rule {
        apply_server_side_encryption_by_default {
        sse_algorithm  =  "aws:kms"
        }
    }
}

# bucket ownership
resource "aws_s3_bucket_ownership_controls" "bucket-owner" {
    bucket = aws_s3_bucket.mybucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

# bucket acl, configure as private bucket
resource "aws_s3_bucket_acl" "bucket-acl" {
    bucket = aws_s3_bucket.mybucket.id
    acl    = "private"
    depends_on = [aws_s3_bucket_ownership_controls.bucket-owner]
}