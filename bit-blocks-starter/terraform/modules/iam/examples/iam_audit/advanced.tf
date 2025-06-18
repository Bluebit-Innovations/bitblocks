module "iam_audit" {
  source = "../../iam_audit"

  prefix                    = "bluebit-prod"
  enable_access_analyzer    = true
  enable_config_rules       = true
  create_readonly_role      = true
  enable_athena_logs        = true

  trusted_auditor_arns = [
    "arn:aws:iam::111122223333:role/SecurityTeam",
    "arn:aws:iam::444455556666:role/Auditor"
  ]

  tags = {
    Project     = "iam-security"
    Environment = "production"
    Compliance  = "yes"
    Owner       = "cloud-team"
  }
}
