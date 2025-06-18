# AWS SSM Patch Baseline Module (sec_ssm_baseline)

This Terraform module is part of the **Bluebit Security Baseline Pack**. It automates secure configuration, patching, and operational compliance for EC2 instances using AWS Systems Manager (SSM).

---

## 📌 Features

- ✅ Enforces OS patch baselines with customizable filters
- ✅ Deploys and associates secure SSM configuration documents
- ✅ Automates patching schedules via SSM Association
- ✅ Supports tagging, compliance scoring, and severity controls
- ✅ Integrates easily into greenfield and brownfield environments

---

## 🚀 Usage

### Basic Example

```hcl
module "sec_ssm_baseline" {
  source = "git::https://github.com/bluebit-cloud-modules/sec_ssm_baseline.git"

  patch_baseline_name   = "baseline-linux-patch"
  approved_patches      = []
  operating_system      = "AMAZON_LINUX_2"
  approve_after_days    = 7
  compliance_level      = "CRITICAL"
  enable_non_security   = false
  patch_classifications = ["Security"]
  patch_severities      = ["Critical", "Important"]

  config_doc_name = "ssm-secure-config"
  config_doc_file = "baseline_doc.yaml"

  patching_cron = "rate(7 days)"
  instance_ids  = ["i-0123456789abcdef0"]

  tags = {
    Environment = "production"
    Owner       = "secops"
  }
}
````

---

## 📥 Input Variables

| Name                    | Type           | Description                                    | Default                     | Required |
| ----------------------- | -------------- | ---------------------------------------------- | --------------------------- | -------- |
| `patch_baseline_name`   | `string`       | Name of the patch baseline                     | -                           | ✅        |
| `approved_patches`      | `list(string)` | List of explicitly approved patches            | `[]`                        | ❌        |
| `operating_system`      | `string`       | OS type: `AMAZON_LINUX_2`, `WINDOWS`, etc.     | -                           | ✅        |
| `approve_after_days`    | `number`       | Days after which patches are approved          | `7`                         | ❌        |
| `compliance_level`      | `string`       | Compliance level: `CRITICAL`, `HIGH`, `MEDIUM` | `"CRITICAL"`                | ❌        |
| `enable_non_security`   | `bool`         | Include non-security patches                   | `false`                     | ❌        |
| `patch_classifications` | `list(string)` | Patch classification filters                   | `["Security"]`              | ❌        |
| `patch_severities`      | `list(string)` | Severity filters                               | `["Critical", "Important"]` | ❌        |
| `config_doc_name`       | `string`       | Name of the SSM Document to deploy             | -                           | ✅        |
| `config_doc_file`       | `string`       | File path to the document (JSON or YAML)       | -                           | ✅        |
| `patching_cron`         | `string`       | CRON expression for patch association schedule | `"rate(7 days)"`            | ❌        |
| `instance_ids`          | `list(string)` | List of instance IDs to target                 | -                           | ✅        |
| `tags`                  | `map(string)`  | Optional tags for resources                    | `{}`                        | ❌        |

---

## 📤 Outputs

| Name                    | Description                               |
| ----------------------- | ----------------------------------------- |
| `patch_baseline_id`     | ID of the created patch baseline          |
| `document_name`         | Name of the secure configuration document |
| `patch_association_id`  | ID of the patching SSM association        |
| `config_association_id` | ID of the config SSM association          |

---

## 🧠 Best Practices

* Use in conjunction with AWS Config for continuous compliance.
* Integrate with CloudWatch or EventBridge for association failure alerts.
* Ensure SSM Agent is pre-installed on instances or via AMI baking.
* Parameterize instance targeting using tags and dynamic discovery in advanced setups.

---

## 🧪 Coming Soon (Premium Features)

* Cross-region replication
* SNS alert integration for failed patch/compliance
* CloudWatch dashboards for association health
* Tag-based dynamic instance targeting
* Integration with CloudTrail Insights for anomaly detection

---

## 📁 File Structure

```plaintext
.
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
└── documents/
    └── baseline_doc.yaml
```

---

## 🧾 License

MIT © Bluebit Information Technology Services
