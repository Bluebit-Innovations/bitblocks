# Terraform Module: IAM Access Analyzer Booster

This Terraform module is part of the AWS Governance Booster Pack and provisions **IAM Access Analyzer** resources to detect resource overexposure and enforce IAM compliance.

---

## ✅ Features

- Enable IAM Access Analyzer across accounts or orgs
- Multi-region deployment support
- Optional archive rules to suppress known findings
- Optional AWS Config integration for compliance monitoring
- Optional SNS alerts on new findings
- Modular and production-ready design

---

## 📦 Resources Created

- `aws_accessanalyzer_analyzer`
- `aws_accessanalyzer_archive_rule` (optional)
- `aws_sns_topic`, `aws_sns_topic_subscription`, `aws_cloudwatch_event_rule`, `aws_cloudwatch_event_target` (optional)
- `aws_config_configuration_recorder`, `aws_config_delivery_channel`, `aws_config_config_rule`, `aws_iam_role`, `aws_s3_bucket` (optional)

---

## 🧾 Inputs

| Name                  | Description                                       | Type    | Default                  |
|-----------------------|---------------------------------------------------|---------|--------------------------|
| `enabled`             | Toggle the entire module                          | `bool`  | `true`                   |
| `analyzer_name`       | Name of the IAM Access Analyzer                   | `string`| `"access-analyzer"`      |
| `analyzer_type`       | Type of analyzer: `ACCOUNT` or `ORGANIZATION`     | `string`| `"ACCOUNT"`              |
| `tags`                | Tags to apply to all resources                    | `map`   | `{}`                     |
| `enable_archive_rule`| Enable suppression rules for findings             | `bool`  | `false`                  |
| `archive_rule_name`  | Name of the archive rule                          | `string`| `"suppress-public-resources"` |
| `archive_filters`     | List of filter blocks (criteria & values)         | `list`  | `[]`                     |
| `enable_sns_alerts`  | Enable SNS alerts for findings                    | `bool`  | `false`                  |
| `sns_topic_name`     | SNS topic name                                    | `string`| `"access-analyzer-alerts"` |
| `alert_email`        | Email address for SNS subscription                | `string`| `""`                     |
| `enable_aws_config`  | Enable AWS Config integration                     | `bool`  | `false`                  |
| `config_bucket_name` | S3 bucket name for AWS Config logs                | `string`| `"config-logs-bucket"`   |

---

## 📤 Outputs

| Name               | Description                           |
|--------------------|---------------------------------------|
| `analyzer_arn`     | ARN of the IAM Access Analyzer        |
| `sns_topic_arn`    | ARN of the SNS topic (if enabled)     |
| `config_bucket_name` | AWS Config S3 bucket name (if enabled) |

---

## 🧪 Examples

### 🚀 Basic Example

```hcl
module "iam_access_analyzer" {
  source         = "./modules/iam-access-analyzer"
  analyzer_name  = "prod-access-analyzer"
  analyzer_type  = "ACCOUNT"
  tags = {
    Project = "GovernanceBooster"
    Env     = "prod"
  }
}
````

---

### 🔧 Advanced Example

```hcl
module "iam_access_analyzer_advanced" {
  source                 = "./modules/iam-access-analyzer"
  analyzer_name          = "org-analyzer"
  analyzer_type          = "ORGANIZATION"
  enabled                = true
  enable_archive_rule    = true
  archive_rule_name      = "suppress-public-s3"
  archive_filters = [
    {
      criteria = "resourceType"
      eq       = ["AWS::S3::Bucket"]
    },
    {
      criteria = "isPublic"
      eq       = ["true"]
    }
  ]
  enable_sns_alerts      = true
  sns_topic_name         = "access-analyzer-alerts"
  alert_email            = "security@example.com"
  enable_aws_config      = true
  config_bucket_name     = "my-config-log-bucket"
  tags = {
    Environment = "production"
    Team        = "security"
  }
}
```

---

## 🛡️ Best Practices

* Deploy analyzers in all regions where resources exist
* Combine with AWS Config and Security Hub for continuous compliance
* Use archive rules to reduce alert noise
* Validate policies in CI/CD using tools like [`terraform-iam-policy-validator`](https://github.com/awslabs/terraform-iam-policy-validator)

---

## 🧩 License

MIT — open for commercial and private use.

