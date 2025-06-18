module "advanced_secret" {
  source                   = "../../sec_secretsmanager_baseline"
  region                   = "us-east-1"
  secret_name              = "my-secret-advanced"
  secret_description       = "Production database password"
  enable_rotation          = true
  lambda_zip_path          = "./lambda_rotation_function.zip"
  lambda_env_vars          = { DB_HOST = "db.example.com" }
  enable_usage_alerts      = true
  sns_topic_arn            = "arn:aws:sns:us-east-1:123456789012:SecretAlerts"
  access_alert_threshold   = 5
  rotation_days            = 15
  tags                     = { Environment = "Prod", ManagedBy = "Terraform" }
}