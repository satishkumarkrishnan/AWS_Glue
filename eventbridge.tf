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

/*resource "aws_cloudwatch_event_rule" "console" {
  name        = "capture-ec2-scaling-events"
  description = "Capture all EC2 scaling events"

  event_pattern = jsonencode({ 
    {
    "source": [
        "aws.s3"
    ],
    "detail-type": [
        "Object Created",
        "Object Deleted",
        "Object Tags Added",
        "Object Tags Deleted"
    ],

    "detail": {
        "bucket": {
            "name": [
                "${aws_s3_bucket.example1.id}"
            ]
        },
        "object" : {
            "size": [{"numeric" :["<=", 100 ] }]
        }
    }
    }
}*/

#Resource creation for AWS Cloud Watch event target to store the events in target cloudwatch
resource "aws_cloudwatch_event_target" "cloudwatch_target" {
  target_id = "cloudwatchtarget"
  rule = aws_cloudwatch_event_rule.event_from_s3.name
  arn  = "${aws_cloudwatch_log_group.eventbridge_log_group.arn}" 
}

resource "aws_cloudwatch_event_permission" "allow_s3_cloudwatch_permission" {
  principal = "590183849298"
  statement_id = "AllowSameAccountRole"
  action = "events:PutEvents"
  event_bus_name = "default"
}