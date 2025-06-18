provider "aws" {
  region                      = var.region != "" ? var.region : "us-east-1"
  access_key                  = var.access_key != "" ? var.access_key : "test"
  secret_key                  = var.secret_key != "" ? var.secret_key : "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  endpoints {
    # (optional: for localstack or custom endpoints)
  }
}