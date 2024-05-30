resource "aws_cloudtrail" "example" {
  name = "tokyo_cloudtrail1"
  s3_bucket_name = aws_s3_bucket.example1.id

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}