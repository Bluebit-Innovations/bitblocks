module "sec_s3_policy_hardener_basic" {
  source = "../../sec_prem_s3_policy_hardener"  # Adjust based on your folder structure

  enabled            = true
  create_remediation = true
}
