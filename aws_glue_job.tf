resource "aws_glue_job" "example" {
  name = "DDSL_Glue_job"
  role_arn = aws_iam_role.gluerole.arn
  command {
    name            = "gluestreaming"
    script_location = "s3://${aws_s3_bucket.example1.bucket}/example.py"
  }
} 
