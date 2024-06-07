#Cloudwatch -# Resource creation for IAM role for Cloudwatch
resource "aws_iam_role" "cloudtrail_cloudwatch_events_role" {
  name               = "cloudtrail_cloudwatch_events_role"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Cloudwatch -Resource creation for IAM role policy for Cloudwatch
resource "aws_iam_role_policy" "aws_iam_role_policy_cloudTrail_cloudWatch" {
  name = "cloudTrail-cloudWatch-policy"
  role = aws_iam_role.cloudtrail_cloudwatch_events_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream2014110",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents20141101",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
            ]
        }
    ]
}
EOF
}

#Eventbridge - Creating a IAM role for Eventbridge
resource "aws_iam_role" "eventbridge_role" {
  name               = "Eventbridgerole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

#Eventbridge - Creating a IAM Role policy for Eventbridge
resource "aws_iam_role_policy" "eventbridge_policy" {
  role = aws_iam_role.eventbridge_role.id
  policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",          
            "Resource": "arn:aws:logs:ap-northeast-1:590183849298:log-group:/aws/events/eventbridgelogs:*",
            "Sid": "TrustEventsToStoreLogEvent"
        }
    ],
    "Version": "2012-10-17"
  })
}

# Eventbridge - Create IAM policy for AWS Step Function to invoke-stepfunction-role-created-from-cloudwatch
resource "aws_iam_policy" "policy_invoke_eventbridge" {
  name        = "stepFunctionSampleEventBridgeInvocationPolicy" 
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
             "Action": [ 
                "states:StartExecution",
                "events:PutTargets",
                "events:PutRule",
                "events:DescribeRule",
                "events:PutEvents" 
                ],
            "Resource": [ "arn:aws:states:*:*:stateMachine:*" ]
        }
     ]
   
}
EOF           
}

#Eventbridge - AWS resource for Eventbridge policy attachment
resource "aws_iam_policy_attachment" "eventbridge_policy_attachment" {
  name = "eventbridge_policy"
  roles = [aws_iam_role.eventbridge_role.name]
  policy_arn = aws_iam_policy.policy_invoke_eventbridge.arn
}

# Stepfunction - Create IAM role for AWS Step Function
/*resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunction_role"
  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
             "Action": [ "states:StartExecution" ],
            "Resource": [ "arn:aws:states:*:*:stateMachine:*" ]
        }
     ]
}  
)
}*/
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepfunction_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      },
    ]
  })
}

#Stepfunction - Create IAM policy for AWS Step function
resource "aws_iam_policy" "stepfunction_invoke_gluejob_policy" {
  name = "tokyo_stepfunction_invoke_gluejob"
  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "states:StartExecution"
            ],
            "Resource": "*"
            #"Resource": [
               # "arn:aws:states:ap-northeast-1:590183849298:stateMachine:sample-state-machine"				
           # ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:StopExecution"
            ],
            "Resource": [
               "arn:aws:states:ap-northeast-1:590183849298:execution:sample-state-machine:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "events:PutTargets",
                "events:PutRule",
                "events:DescribeRule",
                "events:PutEvents"                
            ],
            "Resource": [
               "arn:aws:events:ap-northeast-1:590183849298:rule/s3_put_object_event"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
               
                "logs:CreateLogStream",                
                "logs:PutLogEvents"                
            ],
            "Resource": "*"
             #  "arn:aws:logs:ap-northeast-1:590183849298:log-group:/aws/events/stepfunctionlogs:destination:*"           
           # ]
        }
    ]
})
}

#Stepfunction - AWS resource for stepfunction policy attachment
resource "aws_iam_policy_attachment" "stepfunction_policy_attachment" {
  name = "stepfunction_policy"
  roles = [aws_iam_role.iam_for_sfn.name]
  policy_arn = aws_iam_policy.stepfunction_invoke_gluejob_policy.arn
}

# AWS Glue - IAM Resource for Gluejob
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
#AWS Glue -IAM Glue policy
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
                "logs:*"                
            ],
            "Resource": "*"
        }
    ]
}
  )
}

#AWS Glue - AWS resource for Glue policy attachment
resource "aws_iam_policy_attachment" "glue_policy_attachment" {
  name = "glue_policy"
  roles = [aws_iam_role.gluerole.name]
  policy_arn = aws_iam_policy.gluepolicy.arn
}