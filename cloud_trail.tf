/*resource "aws_cloudtrail" "example" {
  name = "tokyo_cloud_trail"
  s3_bucket_name = aws_s3_bucket.example1.id

  event_selector {
    read_write_type           = "All"
    include_management_events = false

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}*/
#Resource to create Cloudwatch log group
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "tokyo_cloudwatch_log"
  tags = {
    Name = "Cloudwatch for backuping CloudTrail"    
  }
}
# Resource to create Cloudtrail
resource "aws_cloudtrail" "trail" {
  name                       = "tokyo_cloudtrail"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_events_role.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudwatch_log_group.arn}:*" 
  enable_log_file_validation = "false"
  enable_logging             = "true"
  is_multi_region_trail      = "false"
 #kms_key_id                 = aws_kms_key.cloudtrail-logs-kms-key.arn
  s3_bucket_name             = aws_s3_bucket.example1.id
  depends_on                 = [aws_s3_bucket_policy.logs]  
  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::${aws_s3_bucket.example1.id}/"]
    }
  }
}


/*resource "aws_cloudwatch_log_stream" "test" {
  name           = "${data.aws_caller_identity.current.account_id}_CloudTrail_${data.aws_region.current.name}"
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
}*/