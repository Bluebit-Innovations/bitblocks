module "basic_secret" {
  source       = "../../sec_secretsmanager_baseline"
  region       = "us-east-1"
  secret_name  = "my-secret-basic"
  tags         = { Environment = "Prod" }
}