# 📂 Examples - AWS Governance Booster Pack

This directory contains **usage examples** for each module in the AWS Governance Booster Pack. These examples are designed to help you quickly understand how to integrate the modules into your infrastructure — whether you're bootstrapping a new AWS environment or enhancing an existing one.

---

## 🔧 How to Use

Each subfolder corresponds to a specific governance module and demonstrates **basic** and/or **advanced** usage patterns.

> 💡 **Tip:** These examples are tested against Terraform `>= 1.3` and AWS Provider `>= 5.0`.

To use an example:

```bash
cd examples/gov_audit/basic
terraform init
terraform apply
````

You may need to customize variable values based on your environment (e.g., AWS account ID, region, org ID).

---

## 📁 Example Structure

```
examples/
│
├── gov_audit/
│   ├── basic.tf         # Minimal example for enabling audit logging
│   └── advanced.tf      # Extended configuration with CloudWatch + S3 + KMS
│
├── gov_org/
│   ├── basic.tf         # Create OUs and delegated accounts
│   └── advanced.tf      # OU structure, delegation, SCPs, account factory
│
├── gov_scp/
│   ├── inline-policy.tf # Create SCP using inline definition
│   └── file-policy.tf   # Create SCP using external JSON file
│
├── gov_cloudtrail/
│   ├── basic.tf  
│   └── advanced.tf      # Multi-region encrypted logging with lifecycle policies
│
├── gov_accessanalyzer/
│   └── basic.tf         # Enable Access Analyzer and validate findings
│   └── advanced.tf  
│
│
└── gov_tagging/
    └── basic.tf         # Enforce or validate tagging strategy using Config
    └── advanced.tf  

```

---

## ✅ Tested Scenarios

| Example Path                 | Scenario                                                           |
| ---------------------------- | ------------------------------------------------------------------ |
| `gov_audit/basic.tf`         | Enables minimal CloudTrail logging with default settings           |
| `gov_org/advanced.tf`        | Deploys full org hierarchy and links SCPs                          |
| `gov_scp/file-policy.tf`     | Loads multiple SCPs from external JSON files                       |
| `gov_cloudtrail/advanced.tf` | Enables centralized logging with encryption and retention policies |
| `gov_config/basic.tf`        | Deploys AWS Config with managed rules for compliance auditing      |

---

## 🧪 Testing and Validation

You can test modules independently using Terraform CLI:

```bash
terraform plan -var-file="dev.tfvars"
terraform apply
```

For automation, consider integrating with pre-commit hooks or pipelines to validate consistency across modules.

---

## 📬 Feedback & Contributions

If you find issues, missing use cases, or have suggestions — feel free to open a pull request or submit an issue.

Together, we can build a powerful governance framework for AWS.

---

> © Bluebit IT Services – All rights reserved

