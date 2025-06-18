# AWS GuardDuty Terraform Module (`sec_guardduty`)

This Terraform module enables and configures AWS GuardDuty across one or multiple regions with optional integration into AWS Organizations, KMS encryption, and SNS notification support.

---

## 🔒 Use Cases

- Intelligent threat detection and monitoring
- Multi-region security baseline enforcement
- Compliance and audit readiness (HIPAA, PCI-DSS, ISO27001)
- SIEM/SOAR alerting via SNS
- Extended protection for S3, EC2, EKS

---

## ⚙️ Features

- ✅ Multi-region GuardDuty detector deployment
- ✅ Optional GuardDuty delegated admin setup for AWS Organizations
- ✅ S3, Kubernetes, and Malware data source activation
- ✅ Optional SNS publishing and KMS encryption
- ✅ Production-grade tagging and modular design

---

## 📦 Module Usage

### ✅ Basic Example

```hcl
module "guardduty_basic" {
  source  = "../../modules/sec_guardduty"

  enabled = true
  regions = ["us-east-1"]
}
````

---

### ✅ Advanced Example

```hcl
module "guardduty_advanced" {
  source                     = "../../modules/sec_guardduty"

  enabled                    = true
  regions                    = ["us-east-1", "eu-west-1"]
  publish_findings_to_sns    = true
  sns_topic_arn              = "arn:aws:sns:us-east-1:123456789012:gd-findings"
  kms_key_arn                = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"
  enable_organization_admin  = true

  tags = {
    Environment = "prod"
    Team        = "Security"
  }
}
```

---

## 🔧 Inputs

| Name                        | Type           | Default         | Description                                            |
| --------------------------- | -------------- | --------------- | ------------------------------------------------------ |
| `enabled`                   | `bool`         | `true`          | Enable or disable the module                           |
| `regions`                   | `list(string)` | `["us-east-1"]` | Regions where GuardDuty will be enabled                |
| `publish_findings_to_sns`   | `bool`         | `false`         | Enable SNS publishing for findings                     |
| `sns_topic_arn`             | `string`       | `null`          | SNS topic ARN to which findings are sent               |
| `kms_key_arn`               | `string`       | `null`          | KMS key ARN to encrypt exported findings               |
| `enable_organization_admin` | `bool`         | `false`         | Enable GuardDuty delegated admin for AWS Organizations |
| `tags`                      | `map(string)`  | `{}`            | Tags applied to resources                              |

---

## 📤 Outputs

| Name                         | Description                                             |
| ---------------------------- | ------------------------------------------------------- |
| `guardduty_detector_ids`     | Map of region to GuardDuty detector IDs                 |
| `guardduty_admin_account_id` | Admin account ID if organization admin setup is enabled |
| `guardduty_sns_destinations` | List of SNS destination ARNs for GuardDuty findings     |

---

## 🛡️ Requirements

* AWS Provider `>= 5.0`
* Terraform `>= 1.3.0`

---

## 🧠 Best Practices

* Use in centralized security or audit account
* Enable across all AWS regions used by your workloads
* Integrate findings with SIEM tools or incident response workflows

````

---

## ✅ `/examples/basic/main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

module "guardduty_basic" {
  source  = "../../modules/sec_guardduty"

  enabled = true
  regions = ["us-east-1"]
}
````

---

## ✅ `/examples/advanced/main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

module "guardduty_advanced" {
  source                     = "../../modules/sec_guardduty"

  enabled                    = true
  regions                    = ["us-east-1", "eu-west-1"]
  publish_findings_to_sns    = true
  sns_topic_arn              = "arn:aws:sns:us-east-1:123456789012:gd-findings"
  kms_key_arn                = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"
  enable_organization_admin  = true

  tags = {
    Environment = "production"
    Owner       = "SecurityTeam"
  }
}
