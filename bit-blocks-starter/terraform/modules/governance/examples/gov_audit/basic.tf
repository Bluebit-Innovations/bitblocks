#############################
# examples/basic.tf
#############################

module "gov_audit_basic" {
  source = "../../gov_audit"

  config_bucket_name  = "my-basic-audit-bucket"
  config_role_arn     = "arn:aws:iam::123456789012:role/AWSConfigRole"
  aggregator_role_arn = "arn:aws:iam::123456789012:role/AggregatorRole"

  enable_config       = true
  enable_guardduty    = true
  enable_security_hub = false
  enable_aggregator   = false
  regions             = ["us-east-1"]
}