resource "aws_config_configuration_recorder" "configrecorder" {
  name = "ddsl_resource_config_recorder"
  role_arn = aws_iam_role.config_role.arn

   recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types                = ["AWS::Glue::Job", "AWS::S3::Bucket"]
  }

   recording_mode {
    recording_frequency = "DAILY"
  }
}



resource "aws_config_config_rule" "configrule" {
  name = "ddslconfigrule"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.configrecorder]
}   