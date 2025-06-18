# Tag Governance Module for AWS Organizations

This Terraform module enforces and validates tag policies across AWS Organizations using AWS Organizations Tag Policies, AWS Config, and optional SNS alerts. It is part of the Governance Booster Pack and helps organizations implement tagging best practices to improve cost tracking, automation, and compliance.

---

## 📦 Features

- ✅ Organization-level tag enforcement using `TAG_POLICY`
- ✅ AWS Config rule for required tags
- ✅ Optional SNS alerts on non-compliance
- ✅ Flexible for both greenfield and brownfield environments
- ✅ Production-grade and modular

---

## 🧩 Use Cases

- Enforce `Environment`, `Owner`, and other critical tags across AWS accounts
- Receive compliance alerts for missing or incorrect tags
- Align with AWS best practices and compliance frameworks (CIS, NIST, etc.)
- Integrate into a larger governance automation strategy

---

## 🚀 Module Usage

### ✅ Basic Example

```hcl
module "tag_governance" {
  source                 = "../modules/tag_governance"
  tag_policy_name        = "enforce-core-tags"
  tag_policy_description = "Ensure all resources have Environment and Owner tags"
  target_ou_id           = "ou-xxxx-yyyyyyyy"
}
````

### ⚙️ Advanced Example (with SNS Compliance Alerts)

```hcl
module "tag_governance" {
  source                 = "../modules/tag_governance"
  tag_policy_name        = "strict-tagging-policy"
  tag_policy_description = "Tag policy with alerts and extended config scope"
  target_ou_id           = "ou-xxxx-yyyyyyyy"
  enable_sns_alerts      = true
  config_resource_types  = ["AWS::EC2::Instance", "AWS::S3::Bucket", "AWS::RDS::DBInstance"]
}
```

---

## 🔧 Inputs

| Name                     | Description                                   | Type           | Default                                     | Required |
| ------------------------ | --------------------------------------------- | -------------- | ------------------------------------------- | -------- |
| `tag_policy_name`        | Name of the AWS Tag Policy                    | `string`       | `n/a`                                       | ✅        |
| `tag_policy_description` | Description for the Tag Policy                | `string`       | `"Enforce required tags"`                   | ❌        |
| `target_ou_id`           | AWS OU or account ID to attach the policy     | `string`       | `n/a`                                       | ✅        |
| `config_resource_types`  | AWS resource types for AWS Config enforcement | `list(string)` | `["AWS::EC2::Instance", "AWS::S3::Bucket"]` | ❌        |
| `enable_sns_alerts`      | Enable SNS alerting for tag non-compliance    | `bool`         | `false`                                     | ❌        |

---

## 📤 Outputs

| Name            | Description                                                 |
| --------------- | ----------------------------------------------------------- |
| `tag_policy_id` | The ID of the tag policy created                            |
| `sns_topic_arn` | The ARN of the SNS topic for compliance alerts (if enabled) |

---

## 🛡️ Optional Enhancements

* Add CloudFormation StackSet integration
* Enable S3 backups for tag policy versioning
* Create Lambda auto-remediation for non-compliant tags

---

## 📚 Resources

* [AWS Organizations Tag Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html)
* [AWS Config Required Tags Rule](https://docs.aws.amazon.com/config/latest/developerguide/required-tags.html)
* [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

© 2025 Bluebit IT Services – All rights reserved.

