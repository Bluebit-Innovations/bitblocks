# Secrets Manager Baseline Terraform Module (`sec_secretsmanager_baseline`)

This module creates a secure and compliant AWS Secrets Manager lifecycle and auditing baseline.

## Features

- **Automated Secrets Rotation** via AWS Lambda
- **Encryption at rest** with AWS KMS
- **Usage Tracking & Alerting** with AWS CloudWatch alarms
- Compliance-ready tagging & auditing

## Usage

### Basic Example:
```hcl
module "basic_secret" {
  source       = "path/to/sec_secretsmanager_baseline"
  region       = "us-east-1"
  secret_name  = "my-secret-basic"
  tags         = { Environment = "Prod" }
}
````

### Advanced Example:

```hcl
module "advanced_secret" {
  source                 = "path/to/sec_secretsmanager_baseline"
  region                 = "us-east-1"
  secret_name            = "my-secret-advanced"
  secret_description     = "Production database password"
  enable_rotation        = true
  lambda_zip_path        = "./lambda_rotation_function.zip"
  lambda_env_vars        = { DB_HOST = "db.example.com" }
  enable_usage_alerts    = true
  sns_topic_arn          = "arn:aws:sns:us-east-1:123456789012:SecretAlerts"
  access_alert_threshold = 5
  rotation_days          = 15
  tags                   = { Environment = "Prod", ManagedBy = "Terraform" }
}
```

## Optional Enhancements

* **Custom Rotation Lambda**: Add your rotation logic via Lambda.
* **Fine-grained Alarms**: Tune alert thresholds based on usage.
* **Multi-region deployment**: Manage secrets across AWS regions.
* **Compliance-focused tagging**: Leverage tagging for resource classification.

## Best Practices Followed

* AWS KMS-managed encryption keys with rotation
* Principle of least privilege for Lambda execution
* Automated and monitored secrets rotation
* Easy integration into existing and new environments

---

## Contributions & Issues

Report issues or contribute improvements via GitHub issues or pull requests.

---

## License

MIT © \[Bluebit Information Technology Services]

