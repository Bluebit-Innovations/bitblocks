
module "sec_compliance_findings_basic" {
  source = "../../sec_securityhub"

  enable_securityhub      = true
  enable_cis_standard     = true
  enable_aggregator       = true

  member_accounts = {
    "111122223333" = "security@example.com"
    "444455556666" = "audit@example.com"
  }
}
