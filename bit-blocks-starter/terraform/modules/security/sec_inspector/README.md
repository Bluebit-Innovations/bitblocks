# AWS Security Booster Pack – Inspector Module (`sec_inspector`)

This Terraform module enables **Amazon Inspector** for **EC2**, **ECR**, and **Lambda** resources to detect and remediate software vulnerabilities automatically.

## 🚀 Features

- ✅ Enables Amazon Inspector in standalone or AWS Organizations mode
- ✅ Supports EC2, ECR (Container), and Lambda vulnerability assessments
- ✅ Supports delegated admin for centralized management
- ✅ Production-ready and easy to integrate into greenfield or brownfield projects
- ✅ Designed to meet compliance and security best practices

---

## 📦 Module Usage

### ✅ Basic Usage (Single Account)

```hcl
module "inspector_basic" {
  source                   = "./modules/sec_inspector"
  enable_for_organization = false
  resource_types           = ["EC2", "ECR"]
}
```

### 🏢 Advanced Usage (Organization-wide with Delegated Admin)

```hcl
module "inspector_advanced" {
  source                      = "./modules/sec_inspector"
  enable_for_organization     = true
  resource_types              = ["EC2", "ECR", "LAMBDA"]
  delegated_admin_account_id  = "123456789012"
  auto_enable_ec2             = true
  auto_enable_ecr             = true
  auto_enable_lambda          = true
}
```

---

## 🔧 Inputs

| Name                         | Description                                                          | Type           | Default          | Required |
| ---------------------------- | -------------------------------------------------------------------- | -------------- | ---------------- | -------- |
| `enable_for_organization`    | Enable Inspector2 at the organization level                          | `bool`         | `false`          | no       |
| `resource_types`             | List of resource types to scan (e.g., `EC2`, `ECR`, `Lambda`)        | `list(string)` | `["EC2", "ECR"]` | no       |
| `auto_enable_ec2`            | Automatically enable EC2 scanning for new org accounts               | `bool`         | `true`           | no       |
| `auto_enable_ecr`            | Automatically enable ECR scanning for new org accounts               | `bool`         | `true`           | no       |
| `auto_enable_lambda`         | Automatically enable Lambda scanning for new org accounts            | `bool`         | `false`          | no       |
| `delegated_admin_account_id` | AWS Account ID for delegated Inspector admin (used in org mode only) | `string`       | `""`             | no       |

---

## 📤 Outputs

| Name                | Description                                    |
| ------------------- | ---------------------------------------------- |
| `inspector2_status` | Human-readable status of Inspector2 activation |

---

## 🧩 Optional Enhancements (Not Included)

* 🔔 **SNS Integration** for real-time findings notifications
* 🔗 **Security Hub Aggregation** to centralize alerts
* 🏷️ **Tag-based Filtering** to control scan targets
* 🔁 **SSM Automation** for remediation workflows
* 🌍 **Multi-region Deployment** using module `for_each` pattern

---

## ✅ Requirements

* **Terraform** `>= 1.3`
* **AWS Provider** `>= 5.0`
* AWS Organizations (if using org-level features)

---

## 🛡️ Security & Compliance

Amazon Inspector provides continuous, automated security assessments:

* Detects CVEs in EC2 AMIs and Lambda packages
* Flags container image vulnerabilities in Amazon ECR
* Integrates with AWS Security Hub, EventBridge, and SSM Automation

---

## 🧠 Author

**Bluebit Information Technology Services**
Part of the Security Booster Pack for AWS
📧 [info@bluebit.live](mailto:info@bluebit.live)
🌐 [https://bluebit.live](https://bluebit.live)

---

## 📜 License

MIT License

