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
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name = "tokyo_cloudtrail_log"
  tags = {
    Name = "Cloudwatch for backuping CloudTrail"    
  }
}
# Resource to create Cloudtrail
resource "aws_cloudtrail" "trail" {
  name                       = "tokyo_cloudtrail"
  #depends_on                 = [aws_s3_bucket_policy.logs, aws_iam_role.cloudtrail_cloudwatch_events_role] 
  #cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_events_role.arn
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudtrail_log_group.arn
  #cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudwatch_log_group.arn}:*" 
  #cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*" # CloudTrail requires the Log Stream wildcard
  enable_log_file_validation = "false"
  enable_logging             = "true"
  is_multi_region_trail      = "false"
 #kms_key_id                 = aws_kms_key.cloudtrail_logs_kms_key.arn
  s3_bucket_name             = aws_s3_bucket.example1.id
  include_global_service_events = false 
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
     # values = ["arn:aws:s3"]
      #values = ["${aws_s3_bucket.example1.arn}/"]
      values = ["arn:aws:s3:::${aws_s3_bucket.example1.id}/"]
    }
  }
}
