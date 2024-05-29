resource "aws_iam_policy" "gluepolicy" {
  name = "gluepolicy"
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*",
                "glue:*",
                "iam:ListRolePolicies",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
  )
}
resource "aws_iam_role" "gluerole" {
  name               = "gluerole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "glue.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

// EVENTBRIDGE IAM ROLE POLICY
resource "aws_iam_policy" "eventbridge_invoke_step_function_policy" {
  name = "tokyo_eventbridge_invoke_step_function"
  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
	{
         "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": "*"
     }  
    ]
  })
}

resource "aws_iam_role" "eventbridge_invoke_step_function_role" {
  name = "eventbridge_invoke_step_function_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_stepfunction_policy_to_eventbridge" {
  name = "attach_stepfunction_policy_to_eventbridge"
  roles = [aws_iam_role.eventbridge_invoke_step_function_role.name]
  policy_arn = aws_iam_policy.eventbridge_invoke_step_function_policy.arn
}

