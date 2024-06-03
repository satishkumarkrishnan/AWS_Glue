#Resource to create Cloudwatch log group for logging the cloudtrail logs
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name = "tokyo_cloudtrail_log"
  tags = {
    Name = "Cloudwatch for backuping CloudTrail"    
  }
}

#Resource creation for AWS Cloud Watch log group
resource "aws_cloudwatch_log_group" "eventbridge_log_group" {
  name = "tokyo_eventbridge_log"

  tags = {
    Environment = "Dev"
    Application = "POC"
  }
}
