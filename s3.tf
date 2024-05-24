resource "aws_s3_bucket" "bucket1" {
  bucket = "raw_data_bucket"  
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "extension_data_bucket"
}