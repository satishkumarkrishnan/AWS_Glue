resource "aws_s3_bucket" "rawdatabucket" {
  bucket = "raw-data-bucket"  
# Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "extensionbucket" {
  bucket = "extension-data-bucket"
}