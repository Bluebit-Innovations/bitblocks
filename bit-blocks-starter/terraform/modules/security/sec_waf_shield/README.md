
# Security WAF Shield (sec_waf_shield)

Terraform module to enable **Application-Layer Protection (AWS WAF)** and optional **DDoS Protection (AWS Shield Advanced)** for web-facing resources in AWS.

---

## ✅ Features

- AWS WAFv2 Web ACL creation with managed rule groups
- Optional association with ALB, CloudFront, or API Gateway
- Optional AWS Shield Advanced subscription
- Optional Shield Protection Group for grouping critical resources
- CloudWatch metrics and logging visibility configuration
- Fully configurable, production-ready, and compliance-aware

---

## 📦 Usage

### Basic Example

```hcl
module "waf_shield_basic" {
  source = "github.com/bluebit-tech/security-modules//sec_waf_shield"

  web_acl_name = "bluebit-basic-waf"
  scope        = "REGIONAL"
  resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-app/50dc6c495c0c9188"
}
````

### Advanced Example

```hcl
module "waf_shield_advanced" {
  source = "github.com/bluebit-tech/security-modules//sec_waf_shield"

  web_acl_name              = "bluebit-advanced-waf"
  scope                     = "REGIONAL"
  resource_arn              = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/advanced-app/50dc6c495c0c9188"
  enable_shield_protection  = true
  enable_protection_group   = true
  shield_group_name         = "bluebit-critical-apps"
  shield_group_members      = [
    "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/app1/50dc6c495c0c9188",
    "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/app2/60ec7c395d1d9289"
  ]

  tags = {
    Project     = "bluebit"
    Environment = "production"
    Owner       = "security-team"
  }
}
```

---

## 🔧 Inputs

| Name                       | Description                                            | Type           | Default               | Required |
| -------------------------- | ------------------------------------------------------ | -------------- | --------------------- | -------- |
| `web_acl_name`             | Name for the WAF Web ACL                               | `string`       | `n/a`                 | ✅ Yes    |
| `scope`                    | Scope of WAF (`REGIONAL` or `CLOUDFRONT`)              | `string`       | `REGIONAL`            | ❌ No     |
| `resource_arn`             | Resource to associate with WAF and/or Shield           | `string`       | `""`                  | ❌ No     |
| `enable_shield_protection` | Enable AWS Shield Advanced on the resource             | `bool`         | `false`               | ❌ No     |
| `enable_protection_group`  | Enable Shield protection group                         | `bool`         | `false`               | ❌ No     |
| `shield_group_name`        | Name of the Shield protection group                    | `string`       | `"bluebit-sec-group"` | ❌ No     |
| `shield_group_members`     | List of resource ARNs to group under Shield protection | `list(string)` | `[]`                  | ❌ No     |
| `tags`                     | Key-value tags for all resources                       | `map(string)`  | `{}`                  | ❌ No     |

---

## 📤 Outputs

| Name                   | Description                              |
| ---------------------- | ---------------------------------------- |
| `web_acl_arn`          | ARN of the WAF Web ACL                   |
| `web_acl_id`           | ID of the WAF Web ACL                    |
| `shield_protection_id` | ID of the Shield protection (if enabled) |

---

## 🛡 Best Practices

* Use managed rule groups for baseline security
* Integrate with CloudWatch for alerting on WAF/Shield findings
* Enable Shield Advanced only if under Business or Enterprise Support
* Group critical resources into Shield protection groups for visibility

---

## 🧠 Notes

* `scope = CLOUDFRONT` is required for CloudFront use cases.
* Shield Advanced requires manual subscription to the service in the AWS Console.
* Web ACLs can be reused across multiple resources using associations.

---

## 📁 Example Folder Structure

```bash
sec_waf_shield/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── examples/
│   ├── basic.tf
│   └── advanced.tf
└── README.md
```

---

## 🧩 Roadmap Ideas

* Add custom rule support (rate limiting, IP sets, Geo match)
* Enable logging to S3
* Integrate with AWS Firewall Manager for organization-wide control

---

Built and maintained by **Bluebit Security Engineering**
**Contact**: [info@bluebit.live](mailto:info@bluebit.live) | +971 562034575


