module "kms_advanced" {
  source              = "../../sec_kms"
  alias_name          = "app-secrets-key"
  key_description     = "KMS key for encrypting application secrets"
  deletion_window_in_days = 7
  multi_region        = true
  create_grants       = true

  grants = [
    {
      name                      = "AppServerAccess"
      grantee_principal         = "arn:aws:iam::123456789012:role/app-server"
      operations                = ["Encrypt", "Decrypt"]
      encryption_context_equals = { "App" = "Finance" }
    }
  ]
}
