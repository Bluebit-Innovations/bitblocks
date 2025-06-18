module "guardduty_basic" {
  source  = "../../sec_guardduty"

  enabled = true
  regions = ["us-east-1"]
  admin_account_id = "123456789012" # Replace with your actual admin account ID
}