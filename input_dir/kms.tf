#To create KMS resource 
resource "aws_kms_key" "ddsl_kms_key" {
  description             = "KMS key for DDSL"
  deletion_window_in_days = 10
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  tags = {
    Name = "ddsl_kms_key"    
  }
}
#To create KMS Alias
resource "aws_kms_alias" "tokyo_kms_key_alias" {
  name          = "alias/kms_key"
  target_key_id = aws_kms_key.ddsl_kms_key.id
}