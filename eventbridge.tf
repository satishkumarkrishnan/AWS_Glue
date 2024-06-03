resource "aws_cloudwatch_event_rule" "event_from_s3" {
  name = "s3_put_object_event"
  description = "Capture s3 object creation event"
  event_pattern = jsonencode(
    {
        "source": ["aws.s3"],
        "detail-type": ["Object Created"],
        "detail":{
            "bucket": {
                "name": ["${aws_s3_bucket.example1.id}"]
            }
        }
    }
  )   
}
#Resource creation for AWS Cloud Watch log group
resource "aws_cloudwatch_log_group" "eventbridge_log_group" {
  name = "DDSL"

  tags = {
    Environment = "Dev"
    Application = "POC"
  }
}

#Resource creation for AWS Cloud Watch event target to store the events in target cloudwatch
resource "aws_cloudwatch_event_target" "eventbridge_target" {
  target_id = "eventbridgetarget"
  rule = aws_cloudwatch_event_rule.event_from_s3.name
  arn  = aws_cloudwatch_log_group.eventbridge_log_group.arn
}