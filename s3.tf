resource "aws_s3_bucket" "bucket1" {
  bucket = "raw-data-bucket"  
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "extension-data-bucket"
}