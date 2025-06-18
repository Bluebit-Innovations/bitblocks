module "guardduty_advanced" {
  source                     = "../../sec_guardduty"

  enabled                    = true
  regions                    = ["us-east-1", "eu-west-1"]
  publish_findings_to_sns    = true
  sns_topic_arn              = "arn:aws:sns:us-east-1:123456789012:gd-findings"
  kms_key_arn                = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"
  enable_organization_admin  = true
  admin_account_id           = "123456789012"

  tags = {
    Environment = "production"
    Owner       = "SecurityTeam"
  }
}