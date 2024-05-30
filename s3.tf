#To Create SNS Topic 
resource "aws_sns_topic" "topic" {
  name = "s3-event-notification-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.example1.arn}"}
        }
    }]
}
POLICY
}
# S3 bucket to store App
resource "aws_s3_bucket" "example1" {
  bucket = "tokyo-rawdata-bucket"
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
   tags = {
    Name        = "rawdata-bucket"
    Environment = "Dev"
  }
}
#To create a S3 Bucket Notofication 
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = aws_s3_bucket.example1.id
  eventbridge = true
  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]    
    filter_suffix = "*.log"
  }
}

# Enable versioning so you can see the full revision history of your
# state files
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.example1.id
    versioning_configuration {
    status = "Enabled"
  }
}
# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.example1.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.example1.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "logs" {
  bucket     = aws_s3_bucket.example1.id
  policy     = file("${path.module}/cloudtrail-s3-policy.json")
}

resource "aws_kms_key" "cloudtrail-logs-kms-key" {
  key_usage           = "ENCRYPT_DECRYPT"
  enable_key_rotation = false
  policy              = templatefile("${path.module}/cloudtrail-logs-kms-key.json",{ account_id = data.aws_caller_identity.current.account_id })
}

resource "aws_kms_alias" "kms-alias-logs" {
  name          = "alias/logs"
  target_key_id = aws_kms_key.cloudtrail-logs-kms-key.id
}