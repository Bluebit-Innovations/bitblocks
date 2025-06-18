# IAM Service Account Module

This Terraform module creates AWS IAM Roles intended to be used as **service accounts** for workloads such as EKS, Lambda, or CI/CD systems. It supports:
- Assume Role policies
- Inline and Managed policy attachments
- Optional permission boundaries

## ✅ Features

- 🔐 Secure by design (supports permission boundaries)
- 📦 Easy to plug into brownfield or greenfield AWS accounts
- ⚙️ Fully configurable and reusable
- 🔁 Supports both managed and inline IAM policies

---

## 📥 Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the IAM role | `string` | `n/a` | ✅ |
| `assume_role_policy` | IAM Assume Role policy in JSON format | `string` | `n/a` | ✅ |
| `managed_policy_arns` | List of AWS managed or custom managed policy ARNs | `list(string)` | `[]` | ❌ |
| `inline_policies` | Map of inline IAM policies (`{ "policy_name": "json" }`) | `map(string)` | `{}` | ❌ |
| `permissions_boundary` | IAM permission boundary ARN | `string` | `null` | ❌ |
| `tags` | Tags to attach to the IAM role | `map(string)` | `{}` | ❌ |

---

## 📤 Outputs

| Name | Description |
|------|-------------|
| `role_name` | Name of the created IAM role |
| `role_arn` | ARN of the created IAM role |

---

## 🚀 Example Usage

```hcl
module "service_account" {
  source = "./modules/iam_service_account"

  name               = "ci-cd-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]

  inline_policies = {
    "CustomAccess" = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["dynamodb:GetItem"]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }

  permissions_boundary = "arn:aws:iam::123456789012:policy/PermissionBoundary"
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
````

---

## 🛠️ Requirements

* AWS provider >= 4.0
* Terraform >= 1.3

---

## 🧱 Recommended Use Cases

* **EKS IRSA Roles**
* **CI/CD IAM Roles (GitHub Actions, GitLab)**
* **Serverless Execution Roles**
* **Scoped Access for SaaS Integrations**
* **Service Mesh or Microservice Role Isolation**

---

## 📝 License

Distributed under the MIT License. See `LICENSE` file for more information.

---

## 🤝 Support

For feature requests, bug reports, or custom implementations, contact [info@bluebit.live](mailto:info@bluebit.live).




