module "iam_audit_basic" {
  source = "../../iam_audit"

  prefix                    = "bluebit-basic"
  enable_access_analyzer    = true
  enable_config_rules       = true
  create_readonly_role      = true

  trusted_auditor_arns = [
    "arn:aws:iam::123456789012:role/SecurityAuditor"
  ]

  tags = {
    Environment = "dev"
    Owner       = "bluebit"
  }
}
