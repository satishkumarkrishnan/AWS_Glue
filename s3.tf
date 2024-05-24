resource "aws_s3_bucket" "bucket1" {
  bucket = "raw-data-bucket"  
# Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "extension-data-bucket"
}