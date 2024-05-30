resource "aws_cloudtrail" "example" {
  name = tokyo_cloudtrail_log
  s3_bucket_name = aws_s3_bucket.tokyo_cloud_trail.id

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}