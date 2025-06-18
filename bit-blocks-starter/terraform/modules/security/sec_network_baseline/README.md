

# VPC Network Hardening - sec\_network\_baseline

A production-grade Terraform module that establishes **VPC-level network security hardening** for AWS environments. This module is part of the **Security Booster Pack** and enforces AWS security best practices through:

* Centralized VPC Flow Logs
* Default Network ACL and Security Group hardening
* Prevention of public subnet exposure

---

## 🚀 Features

* 🔐 Hardened default Network ACLs (NACLs) – blocks all inbound/outbound by default
* 🛡️ Cleared default Security Groups – removes all default allow rules
* 📉 VPC Flow Logs enabled with optional S3 or CloudWatch destinations
* 🌍 Public subnet egress prevention (optional)
* 🏗️ Works in both greenfield and brownfield environments

---

## 📦 Module Usage

### Basic Usage

```hcl
module "sec_network_baseline" {
  source = "path_to_module"

  vpc_id                  = "vpc-0a12b3456cdef7890"
  default_network_acl_id = "acl-012abc345def678gh"

  name_prefix = "prod-network"
}
```

### Advanced Usage

```hcl
module "sec_network_baseline" {
  source = "path_to_module"

  vpc_id                       = "vpc-0123abc456def7890"
  default_network_acl_id      = "acl-01ab23cd456efg789"
  name_prefix                 = "core-network"
  enable_flow_logs            = true
  flow_log_destination_type   = "s3"
  flow_log_retention_days     = 90
  prevent_public_subnet_access = true
}
```

---

## 📥 Inputs

| Name                           | Description                                                         | Type   | Default              | Required |
| ------------------------------ | ------------------------------------------------------------------- | ------ | -------------------- | -------- |
| `vpc_id`                       | The ID of the VPC                                                   | string | —                    | ✅ Yes    |
| `default_network_acl_id`       | The default NACL ID for the VPC                                     | string | —                    | ✅ Yes    |
| `name_prefix`                  | Prefix to use in naming AWS resources                               | string | `"baseline"`         | No       |
| `enable_flow_logs`             | Whether to enable VPC flow logs                                     | bool   | `true`               | No       |
| `flow_log_destination_type`    | `cloud-watch-logs` or `s3` for flow log destination                 | string | `"cloud-watch-logs"` | No       |
| `flow_log_retention_days`      | Retention period for CloudWatch Logs (ignored if using S3)          | number | `30`                 | No       |
| `prevent_public_subnet_access` | Deny egress to 0.0.0.0/0 in default SG to block public subnet usage | bool   | `true`               | No       |

---

## 📤 Outputs

| Name                   | Description                                   |
| ---------------------- | --------------------------------------------- |
| `flow_log_id`          | The ID of the VPC Flow Log                    |
| `flow_log_destination` | ARN of the log destination (S3 or CloudWatch) |

---

## 🛡️ Security & Compliance

* Follows AWS Well-Architected Framework security guidelines
* Production-ready for regulated industries
* Helps meet compliance for GDPR, SOC2, and ISO 27001 when paired with AWS Config & SecurityHub

---

## 📘 Best Practices

* Use this module in all new and legacy VPCs to enforce secure defaults
* Combine with AWS Config rules and SecurityHub for continuous compliance
* Use centralized logging buckets for all VPC Flow Logs across accounts

---

## 🧪 Testing

* Run `terraform validate` and `terraform plan` against a test VPC
* Integrate into CI/CD pipelines with tools like Checkov, TFLint, and InSpec

---

## 🔧 To Do / Optional Enhancements

* Support for KMS encryption for logs
* Integration with AWS Config rules
* Cross-account S3 logging support
* Custom tagging inputs