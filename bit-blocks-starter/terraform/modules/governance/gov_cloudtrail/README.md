# 🔐 AWS CloudTrail Governance Booster Pack

A production-ready Terraform module for centralized, encrypted, and compliant AWS CloudTrail logging. Supports **multi-region**, **org-wide**, **CloudWatch**, **KMS encryption**, **S3 lifecycle management**, and **CloudTrail Insights** — designed for both greenfield and brownfield deployments.

---

## 🚀 Features

- ✅ Centralized, encrypted CloudTrail log delivery to S3
- ✅ Optional CloudWatch Logs integration
- ✅ Multi-region and organization-wide support
- ✅ Optional CloudTrail Insights for anomaly detection
- ✅ Optional KMS Key creation for encryption
- ✅ Optional S3 Lifecycle Rules for archiving
- ✅ Tags for all resources
- ✅ Module-level enable/disable toggle

---

## 📦 Usage

### `basic.tf` – Minimal Setup (Free Tier)

```hcl
module "gov_cloudtrail_basic" {
  source              = "../../modules/gov_cloudtrail"
  enable_trail        = true
  trail_name          = "core-audit-basic"
  s3_bucket_name      = "my-basic-cloudtrail-logs"
  create_s3_bucket    = true
  account_id          = "123456789012"
  is_multi_region_trail = true
  is_organization_trail = false

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
````

---

### `advanced.tf` – Full Compliance (Paid Tier Features)

```hcl
module "gov_cloudtrail_advanced" {
  source                   = "../../modules/gov_cloudtrail"
  enable_trail             = true
  trail_name               = "enterprise-org-wide-trail"
  s3_bucket_name           = "my-org-cloudtrail-logs"
  create_s3_bucket         = true
  account_id               = "123456789012"
  is_multi_region_trail    = true
  is_organization_trail    = true

  enable_cloudwatch         = true
  cloudwatch_log_group_name = "/aws/cloudtrail/organization"
  log_retention_days        = 180

  enable_lifecycle_rules    = true
  archive_after_days        = 60

  enable_insights           = true
  create_kms_key            = true

  tags = {
    Environment = "prod"
    Compliance  = "SOC2"
    Owner       = "Bluebit"
  }
}
```

---

## ⚙️ Input Variables

| Name                        | Type          | Default                | Description                                      |
| --------------------------- | ------------- | ---------------------- | ------------------------------------------------ |
| `enable_trail`              | `bool`        | `true`                 | Enable or disable CloudTrail trail entirely      |
| `trail_name`                | `string`      | —                      | Name of the CloudTrail                           |
| `s3_bucket_name`            | `string`      | —                      | S3 bucket name to store CloudTrail logs          |
| `create_s3_bucket`          | `bool`        | `true`                 | Whether to create the S3 bucket or use existing  |
| `enable_cloudwatch`         | `bool`        | `false`                | Enable CloudWatch Logs for CloudTrail            |
| `cloudwatch_log_group_name` | `string`      | `/aws/cloudtrail/logs` | CloudWatch log group name                        |
| `log_retention_days`        | `number`      | `90`                   | Retention period for CloudWatch logs             |
| `is_organization_trail`     | `bool`        | `false`                | Enable org-wide logging across accounts          |
| `account_id`                | `string`      | —                      | AWS Account ID (used in bucket policy)           |
| `kms_key_id`                | `string`      | `""`                   | KMS Key ARN if using external encryption         |
| `create_kms_key`            | `bool`        | `false`                | Create new KMS key if no key is provided         |
| `enable_insights`           | `bool`        | `false`                | Enable CloudTrail Insights for anomaly detection |
| `is_multi_region_trail`     | `bool`        | `true`                 | Collect logs across all regions                  |
| `enable_lifecycle_rules`    | `bool`        | `false`                | Enable S3 lifecycle rules for archiving          |
| `archive_after_days`        | `number`      | `90`                   | Days to transition S3 objects to Glacier         |
| `tags`                      | `map(string)` | `{}`                   | Tags to apply to all resources                   |

---

## 📤 Outputs

| Name             | Description                               |
| ---------------- | ----------------------------------------- |
| `trail_arn`      | ARN of the created CloudTrail             |
| `s3_bucket_name` | Name of the S3 bucket used for CloudTrail |
| `kms_key_arn`    | ARN of the KMS Key used for encryption    |

---

## ✅ Compliance-Ready For

* 🔒 SOC 2
* 📄 ISO 27001
* 🧾 PCI-DSS
* 🔍 HIPAA (audit trail coverage)

---

## 🧠 Notes

* Setting `create_kms_key = true` overrides `kms_key_id`
* The `account_id` must match the log source AWS account for the bucket policy to apply correctly
* You can disable the module entirely with `enable_trail = false` to support reusable environments

---

## 📞 Support

This module is part of the **Bluebit Governance Booster Pack**. For enterprise adoption, consulting, or onboarding support, contact **[info@bluebit.live](mailto:info@bluebit.live)**.

