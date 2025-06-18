# Terraform Module: sec_config_compliance

This Terraform module is part of the **Security Booster Pack for AWS**. It establishes foundational **AWS Config** security guardrails by deploying a centralized configuration recorder, delivery channel, and optional **Conformance Packs** (CIS, NIST, HIPAA). It also supports **custom Lambda-backed Config rules** for tailored compliance needs.

---

## ✅ Features

- ✅ Centralized AWS Config Recorder and Delivery Channel setup  
- ✅ Optional deployment of AWS Managed Conformance Packs  
- ✅ Custom Config Rule deployment (Lambda-backed)  
- ✅ Optional compliance notifications via SNS  
- ✅ Easy integration into greenfield and brownfield environments  
- ✅ Supports both `template_body` and `template_s3_uri` for flexibility  

---

## 📦 Module Usage

### Basic Example
```hcl
module "sec_config_compliance" {
  source = "git::https://github.com/your-org/security-booster-pack//modules/sec_config_compliance"

  recorder_role_arn        = aws_iam_role.config_role.arn
  delivery_s3_bucket       = aws_s3_bucket.config_bucket.bucket
}
````

---

### Advanced Example (With Conformance Pack + Custom Rules)

```hcl
module "sec_config_compliance" {
  source = "git::https://github.com/your-org/security-booster-pack//modules/sec_config_compliance"

  recorder_name             = "compliance-recorder"
  recorder_role_arn         = aws_iam_role.config_role.arn
  delivery_channel_name     = "compliance-channel"
  delivery_s3_bucket        = "my-config-logs"
  delivery_sns_topic_arn    = aws_sns_topic.compliance_alerts.arn

  enable_conformance_pack         = true
  conformance_pack_name           = "cis-foundation"
  conformance_pack_template_s3_uri = "s3://compliance-templates/cis-pack.yaml"
  global_resource_region          = "us-east-1"

  custom_rules = {
    s3_bucket_public_read_check = {
      lambda_function_arn     = aws_lambda_function.s3_public_read_checker.arn
      input_parameters        = { "key1" = "value1" }
      max_execution_frequency = "TwentyFour_Hours"
      resource_types          = ["AWS::S3::Bucket"]
    }
  }
}
```

---

## 🔧 Input Variables

| Name                               | Description                            | Type          | Default          | Required |
| ---------------------------------- | -------------------------------------- | ------------- | ---------------- | -------- |
| `recorder_name`                    | Name for the AWS Config Recorder       | `string`      | `"default"`      | No       |
| `recorder_role_arn`                | ARN of IAM role used by AWS Config     | `string`      | n/a              | **Yes**  |
| `delivery_channel_name`            | Name of delivery channel               | `string`      | `"default"`      | No       |
| `delivery_s3_bucket`               | S3 bucket to store config logs         | `string`      | n/a              | **Yes**  |
| `delivery_sns_topic_arn`           | Optional SNS topic for alerts          | `string`      | `null`           | No       |
| `enable_conformance_pack`          | Enable conformance pack deployment     | `bool`        | `false`          | No       |
| `conformance_pack_name`            | Name of the conformance pack           | `string`      | `"default-pack"` | No       |
| `conformance_pack_template_body`   | YAML body of the pack                  | `string`      | `null`           | No       |
| `conformance_pack_template_s3_uri` | URI to conformance pack in S3          | `string`      | `null`           | No       |
| `conformance_pack_s3_bucket`       | Bucket for conformance delivery        | `string`      | `null`           | No       |
| `conformance_pack_s3_prefix`       | Prefix for conformance delivery        | `string`      | `null`           | No       |
| `global_resource_region`           | Region for global resource tracking    | `string`      | `"us-east-1"`    | No       |
| `custom_rules`                     | Map of custom config rules with Lambda | `map(object)` | `{}`             | No       |

---

## 📤 Outputs

| Name                      | Description                                        |
| ------------------------- | -------------------------------------------------- |
| `config_recorder_name`    | Name of the AWS Config Recorder                    |
| `conformance_pack_status` | Name of the deployed conformance pack (if enabled) |

---

## 🧠 Best Practices

* Use a dedicated IAM role with least privilege for the config recorder
* Use S3 lifecycle policies for managing config log storage
* Conformance packs should be version-controlled and updated based on compliance frameworks
* Use [AWS Security Hub](https://docs.aws.amazon.com/securityhub/) for integrating findings from Config

---

## 🔒 Compliance Support

This module helps accelerate alignment with:

* CIS AWS Foundations Benchmark
* NIST 800-53
* HIPAA
* PCI-DSS
* ISO 27001

---

## 🧩 Module Compatibility

| AWS Service       | Supported                                 |
| ----------------- | ----------------------------------------- |
| AWS Config        | ✅                                         |
| S3                | ✅                                         |
| SNS               | ✅                                         |
| Lambda            | ✅ (for custom rules)                      |
| AWS Organizations | ⚠️ Planned support via Config Aggregators |

---

## 📄 License

MIT © \[Your Company]

---

## 🧰 Related Modules

* `sec_guardduty`
* `sec_inspector`
* `sec_securityhub`
* `sec_kms`
* `sec_waf_shield`

