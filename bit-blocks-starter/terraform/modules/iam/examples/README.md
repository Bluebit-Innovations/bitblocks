
# 📁 Examples Directory – IAM Booster Pack

This directory contains usage examples for each module included in the IAM Booster Pack. These examples are meant to guide users on how to implement and extend the modules in real-world use cases.

---

## 📦 Modules and Example Use Cases

### 🔐 `iam_policy/`
Reusable IAM policy module for attaching policies to roles or AWS SSO permission sets.

- `basic.tf` – Create a policy and attach it to IAM roles (no SSO).
- `irsa.tf` – IAM policy used with EKS IRSA roles for pod-level permissions.
- `sso_managed.tf` – Attach AWS-managed policies to an SSO permission set.

---

### 🎭 `iam_role/`
Define IAM roles with flexible trust relationships.

- `basic_trust.tf` – Role assumed by EC2, Lambda, or federated users.
- `cross_account.tf` – Example of a role trusted by a cross-account principal.

---

### ⚙️ `iam_service_account/`
Specialized roles for Kubernetes service accounts using IRSA.

- `eks_irsa.tf` – Role for EKS pod access to AWS services using OIDC trust.

---

## 🧪 How to Use These Examples

Each example can be applied independently by pointing to the relative path of the module:

```hcl
module "example" {
  source = "../../modules/<module_name>"
  # ...inputs...
}
````

You can test or validate each example by running:

```bash
cd examples/iam_policy
terraform init
terraform plan
```

---

## ✅ Best Practices

* Use environment-specific tagging (`Environment`, `Team`, etc.)
* Limit wildcard permissions unless explicitly required
* Prefer role-based and SSO-based access over IAM users/groups
* Keep examples up to date with module changes

---

## 📜 License

These examples are provided under the same license as the root project. Feel free to reuse or adapt them.

---