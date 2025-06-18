# 🛡️ AWS Security Booster Pack

**Production-Ready Terraform Modules for End-to-End AWS Cloud Security**

> Built for DevOps, Platform Teams, and Security-Conscious Organizations

---

## 📦 Overview

The **AWS Security Booster Pack** is a collection of plug-and-play, production-grade Terraform modules designed to help organizations:

- Accelerate compliance readiness (CIS, NIST, ISO, HIPAA)
- Automate security baselines
- Harden cloud environments without blocking innovation
- Enable observability and threat response across accounts

Each module follows AWS best practices and integrates seamlessly into brownfield and greenfield environments.

---

## 📚 Modules Included

| Module                      | Purpose                                                                 |
|----------------------------|-------------------------------------------------------------------------|
| `sec_guardduty`            | Intelligent threat detection using AWS GuardDuty                        |
| `sec_inspector`            | Automated vulnerability scans for EC2 and containers                   |
| `sec_kms`                  | Centralized key management with encryption enforcement                 |
| `sec_securityhub`          | Unified compliance findings and scorecards                            |
| `sec_ssm_baseline`         | Instance hardening, patch management, and secure session logging       |
| `sec_waf_shield`           | Web app firewall and DDoS mitigation                                   |
| `sec_config_compliance`    | Baseline conformance packs (CIS, NIST) using AWS Config                 |
| `sec_cloudtrail_central`   | Multi-account audit logging and secure log storage                     |
| `sec_iam_analyzer`         | Access Analyzer with archive rules for policy visibility               |
| `sec_network_baseline`     | Secure VPC and network-level controls                                  |
| `sec_secretsmanager_baseline` | Encrypted secrets lifecycle management                              |
| `sec_sso_permissions_baseline` | Central IAM access and policy boundaries via AWS Identity Center |
| `sec_backup_policy_enforcer` | Automated backup plans and vault enforcement                         |
| `sec_ebs_snapshot_guard`   | Secure EBS snapshot lifecycle and sharing controls                     |

---

## 🧩 Optional Modules (Enterprise Tier)

| Module                     | Description                                                              |
|---------------------------|--------------------------------------------------------------------------|
| `sec_lambda_guardrails`   | Alerts on overly permissive Lambda roles                                |
| `sec_s3_policy_hardener`  | Detect and remediate public or insecure S3 bucket policies              |
| `sec_eks_baseline`        | Harden Amazon EKS with RBAC, audit logs, and IRSA                        |
| `sec_pentest_monitor`     | Isolate and monitor pentest activities without alert fatigue            |
| `sec_synthetic_guardrails`| Canary alarms for simulating attacks and monitoring behavior            |

---

## 🚀 Getting Started

Each module in this pack is standalone, reusable, and documented with:
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `examples/` with `basic.tf` and `advanced.tf`

### Prerequisites
- Terraform v1.4+
- AWS CLI credentials or SSO session
- Optional: Backend (e.g., S3 + DynamoDB) for remote state

---

## 🔧 Example Usage

```hcl
module "guardduty" {
  source = "bluebit-tech/security-booster/sec_guardduty"
  enable = true
  finding_publishing_frequency = "SIX_HOURS"
}
````

```hcl
module "kms" {
  source = "bluebit-tech/security-booster/sec_kms"
  key_alias = "my-secure-app"
  enable_key_rotation = true
}
```

Find detailed examples in the `examples/` directory of each module.

---

## 🔐 Compliance Alignment

The Security Booster Pack supports control alignment for:

* ✅ [CIS AWS Foundations Benchmark](https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html)
* ✅ NIST 800-53
* ✅ ISO/IEC 27001
* ✅ PCI-DSS
* ✅ HIPAA

---

## 🌍 Multi-Account & Region Ready

* Designed to work with AWS Organizations
* Multi-region analyzer and trail support
* Regional opt-in toggle
* IAM Identity Center-aware for centralized access

---

## 📤 Outputs

Each module exposes key outputs such as:

* Security tool ARNs
* Compliance scores
* KMS key IDs
* SNS topics for alerting
* Audit bucket names
* IAM Permission Set IDs (SSO)

---

## 📈 Monitoring & Alerting

Modules integrate with:

* Amazon EventBridge
* AWS SNS
* AWS Security Hub Insights
* AWS Config Remediation Rules

Optional: Integrate with external SIEM tools (e.g., Splunk, Datadog, OpenSearch)

---

## 💼 Licensing & Commercial Use

This Booster Pack is:

* ✅ Free for individual and internal team use
* 💼 Commercial license required for resale or bundled SaaS use
* 🔐 Premium features available in the **Enterprise Edition**

---

## 👥 Contributors

Maintained by **Bluebit Information Technology Services**
📍 Dubai, UAE
🔗 [https://bluebit.live](https://bluebit.live)
📧 [info@bluebit.live](mailto:info@bluebit.live)

---

## 📌 Disclaimer

This module set provides security best practices and controls for AWS environments but **does not guarantee compliance** with any framework or standard. It should be paired with internal security reviews and audits.

---

## 🧭 Roadmap

* [ ] SaaS UI for module configuration
* [ ] Prebuilt Compliance Dashboards
* [ ] Automated Remediation AI Agent
* [ ] SOC 2 Pack Add-on

