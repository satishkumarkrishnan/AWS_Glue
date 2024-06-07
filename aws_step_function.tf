// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "sample-state-machine" 
  
  role_arn = aws_iam_role.iam_for_sfn.arn
    definition = <<EOF
{
  "Comment": "To trigger events from s3 to stepfunction to AWS Glue",
  "StartAt": "DDSL_Glue_job",
  "States": {
    "DDSL_Glue_job": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun",   
      "Parameters": {
        "JobName": "${aws_glue_job.example.name}"
      },  
      "End": true
    }
  }
}
EOF
logging_configuration {
  log_destination = "${aws_cloudwatch_log_group.stepfunction_log_group.arn}:*"
  include_execution_data = true
  level = "ALL"  
}
}  
