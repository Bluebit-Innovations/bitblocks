# AWS Governance Booster Pack – `gov_audit` Module

This Terraform module enables audit and compliance foundations for AWS Organizations. It integrates AWS Config, Security Hub, GuardDuty, and organization-wide audit features to help you meet enterprise compliance requirements.

## 🔧 Features

- AWS Config recording and delivery
- Security Hub with standard and custom standards
- GuardDuty across regions
- AWS Config Aggregator for centralized visibility
- Delegated Admin setup for SecurityHub/GuardDuty
- Optional: S3 Lifecycle rules for AWS Config logs
- Optional: SNS notifications for audit events

## 📦 Module Usage

### `basic.tf`

```hcl
module "gov_audit" {
  source                = "./modules/gov_audit"
  config_bucket_name    = "my-config-bucket"
  config_role_arn       = "arn:aws:iam::123456789012:role/AWSConfigRole"
  aggregator_role_arn   = "arn:aws:iam::123456789012:role/AggregatorRole"

  enable_config         = true
  enable_guardduty      = true
  enable_security_hub   = false
  enable_aggregator     = false
}
````

### `advanced.tf`

```hcl
module "gov_audit" {
  source                   = "./modules/gov_audit"
  config_bucket_name       = "my-org-audit-logs"
  config_role_arn          = "arn:aws:iam::123456789012:role/AWSConfigRecorderRole"
  aggregator_role_arn      = "arn:aws:iam::123456789012:role/AggregatorRole"
  aggregator_account_id    = "123456789012"

  enable_config            = true
  enable_guardduty         = true
  enable_security_hub      = true
  enable_sh_findings_agg   = true
  enable_cross_region_agg  = true
  enable_aggregator        = true
  assign_delegated_admin   = true

  security_hub_standards   = [
    "aws-foundational-security-best-practices",
    "cis-aws-foundations-benchmark"
  ]

  conformance_pack_names   = ["Operational-Best-Practices-for-NIST-CSF"]
  enable_custom_rules      = true
  enable_log_archive       = true
  log_bucket_name          = "my-centralized-log-archive"

  enable_sns_notify        = true
  sns_topic_arn            = "arn:aws:sns:us-east-1:123456789012:audit-notify"

  default_tags = {
    Project     = "Governance"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  regions = ["us-east-1", "eu-west-1"]
}
```

## 🧮 Input Variables

| Name                      | Type           | Description                                           | Default         |
| ------------------------- | -------------- | ----------------------------------------------------- | --------------- |
| `config_bucket_name`      | `string`       | S3 bucket name to deliver AWS Config logs             | —               |
| `config_role_arn`         | `string`       | IAM role ARN for AWS Config                           | —               |
| `aggregator_role_arn`     | `string`       | IAM role for AWS Config Aggregator                    | —               |
| `aggregator_account_id`   | `string`       | Central account ID for delegated admin setup          | `null`          |
| `enable_config`           | `bool`         | Enable AWS Config setup                               | `true`          |
| `enable_guardduty`        | `bool`         | Enable GuardDuty                                      | `true`          |
| `enable_security_hub`     | `bool`         | Enable Security Hub                                   | `true`          |
| `enable_sh_findings_agg`  | `bool`         | Enable findings aggregation in Security Hub           | `true`          |
| `enable_aggregator`       | `bool`         | Enable centralized AWS Config Aggregator              | `true`          |
| `enable_cross_region_agg` | `bool`         | Aggregate across all AWS regions                      | `true`          |
| `organization_enabled`    | `bool`         | Whether AWS Organizations is enabled                  | `true`          |
| `assign_delegated_admin`  | `bool`         | Assign delegated admin for GuardDuty and Security Hub | `false`         |
| `conformance_pack_names`  | `list(string)` | Conformance pack names to deploy                      | `[]`            |
| `security_hub_standards`  | `list(string)` | List of Security Hub standards to enable              | `[]`            |
| `enable_custom_rules`     | `bool`         | Enable custom AWS Config rules                        | `false`         |
| `enable_log_archive`      | `bool`         | Enable delivery of logs to a central archive bucket   | `false`         |
| `log_bucket_name`         | `string`       | Name of the S3 bucket for log archiving               | `null`          |
| `enable_sns_notify`       | `bool`         | Enable audit notifications via SNS                    | `false`         |
| `sns_topic_arn`           | `string`       | ARN of the SNS topic to send alerts to                | `null`          |
| `default_tags`            | `map(string)`  | Map of default tags for all resources                 | `{}`            |
| `regions`                 | `list(string)` | AWS regions to deploy services in                     | `["us-east-1"]` |

## 📤 Outputs

| Name                           | Description                           |
| ------------------------------ | ------------------------------------- |
| `config_aggregator_id`         | ID of the AWS Config Aggregator       |
| `security_hub_enabled_regions` | Regions where Security Hub is enabled |
| `guardduty_status`             | Whether GuardDuty was enabled         |

## 🧠 Notes

* This module assumes required IAM roles are already provisioned.
* Ensure AWS Config bucket has proper policies.
* Some services like Security Hub may not be available in all regions.


