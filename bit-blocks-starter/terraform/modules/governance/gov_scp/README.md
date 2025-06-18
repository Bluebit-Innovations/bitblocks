
# 📦 gov_scp – AWS Service Control Policies Terraform Module

This module allows you to **define and apply AWS Organizations Service Control Policies (SCPs)** with advanced features such as:

- ✅ Inline or file-based policy definitions
- ✅ Environment-based targeting (e.g., only apply to `prod`)
- ✅ Policy-level enable/disable toggle
- ✅ Support for multiple OUs or Account targets
- ✅ Scalable for brownfield and greenfield projects

---

## 🚀 Use Cases

- Apply organization-wide guardrails (e.g., deny EC2, deny S3 delete)
- Roll out environment-specific policies (e.g., allow CloudShell in dev but deny in prod)
- Maintain policies in version-controlled JSON files or inline within Terraform
- Easily enable/disable policies during experimentation

---

## 📁 Module Inputs

| Name              | Type    | Description                                                                 |
|-------------------|---------|-----------------------------------------------------------------------------|
| `scp_policies`    | list    | List of policy objects (see structure below)                                |
| `allowed_environments` | list(string) | List of environments allowed to receive SCP attachments (default: all) |

Each SCP object supports the following structure:

```hcl
scp_policies = [
  {
    name             = string
    description      = optional(string, default = "Managed SCP")
    policy_inline    = optional(string)            # For inline use
    policy_file_path = optional(string)            # For file-based use
    use_policy_file  = optional(bool, default = false)
    enabled          = optional(bool, default = true)
    environment      = optional(string, default = "global")
    target_ids       = list(string)                # AWS Account or OU IDs
    tags             = optional(map(string))
  }
]
````

---

## ✅ Examples

### 🟢 Inline SCP (No file)

```hcl
module "gov_scp_inline" {
  source = "../modules/gov_scp"

  allowed_environments = ["prod"]

  scp_policies = [
    {
      name            = "deny-s3-delete"
      description     = "Deny all S3 delete actions"
      policy_inline   = jsonencode({
        Version = "2012-10-17",
        Statement = [{
          Effect   = "Deny",
          Action   = ["s3:DeleteObject", "s3:DeleteBucket"],
          Resource = "*"
        }]
      })
      use_policy_file = false
      target_ids      = ["ou-abc1-12345678"]
      enabled         = true
      environment     = "prod"
    }
  ]
}
```

---

### 📄 File-Based SCP (via JSON file)

```hcl
module "gov_scp_file" {
  source = "../modules/gov_scp"

  allowed_environments = ["prod"]

  scp_policies = [
    {
      name             = "deny-ec2"
      description      = "Block EC2 usage"
      policy_file_path = "policies/deny-ec2.json"
      use_policy_file  = true
      target_ids       = ["ou-prod-87654321"]
      enabled          = true
      environment      = "prod"
    }
  ]
}
```

📂 Sample JSON file (`policies/deny-ec2.json`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllEC2",
      "Effect": "Deny",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
```

---

## 📤 Outputs

| Name       | Description                     |
| ---------- | ------------------------------- |
| `scp_ids`  | Map of SCP names to policy IDs  |
| `scp_arns` | Map of SCP names to policy ARNs |

---

## 🔍 Tips & Best Practices

* Use **file-based SCPs** for larger policies or shared governance (GitOps)
* Use **inline SCPs** for quick testing or tightly coupled setups
* Set `enabled = false` to skip policy creation without deleting it
* Use `allowed_environments` to ensure proper scoping across dev/staging/prod
* SCPs only apply to **accounts/OUs** — not individual users or roles

---

## 🧪 Policy Validation

To validate JSON SCP files manually:

```bash
aws organizations validate-policy \
  --content file://policies/deny-ec2.json \
  --type SERVICE_CONTROL_POLICY
```

Or integrate with CI/CD using tools like:

* ✅ `terraform validate`
* ✅ `checkov` or `conftest`
* ✅ `opa` for custom rules

---

## 🏗 Folder Structure Suggestion

```
terraform/
├── modules/
│   └── gov_scp/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
├── examples/
│   ├── inline-policy.tf
│   ├── file-based-policy.tf
│   └── policies/
│       └── deny-ec2.json
```

---

## 👥 Maintainers

This module is maintained by \[Your Company/Team Name]. Feel free to contribute, fork, and extend as needed.

---

## 📜 License

MIT or Apache 2.0 (set based on your preference)



