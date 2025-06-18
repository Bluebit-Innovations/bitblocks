# AWS Backup Policy Enforcer Module (`sec_backup_policy_enforcer`)

This Terraform module enforces secure, compliance-aligned backup policies across your AWS workloads, utilizing AWS Backup and AWS KMS for encryption. It's designed to seamlessly integrate into greenfield and brownfield environments.

## Features

* **Backup Plan Compliance:** Define robust backup plans aligning with organizational RPO/RTO requirements.
* **Tag-based Resource Selection:** Automatically includes resources for backup based on customizable tag criteria.
* **Secure Backup Vaults:** Uses AWS KMS-managed keys for vault encryption ensuring backup data security.
* **Flexible Backup Rules:** Supports multiple backup schedules and retention policies.
* **Optional SNS Notifications:** Get alerts on backup job completions or failures.

## Prerequisites

* Terraform version `>= 1.6.0`
* AWS Provider version `~> 5.50.0`

## Usage

### Basic Example

```hcl
module "backup_policy_basic" {
  source = "path/to/sec_backup_policy_enforcer"

  region = "us-east-1"

  tags = {
    Environment = "Production"
    Owner       = "OpsTeam"
  }
}
```

### Advanced Example

```hcl
module "backup_policy_advanced" {
  source = "path/to/sec_backup_policy_enforcer"

  region                    = "us-east-1"
  backup_vault_name         = "critical_workloads_vault"
  backup_plan_name          = "critical_rpo_rto_plan"
  kms_key_alias             = "critical_backup_encryption_key"
  backup_schedule_expression = "cron(0 1 * * ? *)"
  delete_after_days         = 90

  additional_backup_rules = [
    {
      rule_name         = "WeeklyFullBackup"
      schedule          = "cron(0 3 ? * SUN *)"
      delete_after_days = 180
      additional_tags   = { "BackupFrequency" = "Weekly" }
    }
  ]

  enable_sns_notifications = true
  sns_topic_arn            = "arn:aws:sns:us-east-1:123456789012:BackupNotifications"

  tags = {
    Environment = "Critical"
    Compliance  = "SOC2"
  }
}
```

## Inputs

| Name                         | Description                                 | Type           | Default                     | Required |
| ---------------------------- | ------------------------------------------- | -------------- | --------------------------- | :------: |
| region                       | AWS Region for resources                    | `string`       | -                           |    yes   |
| backup\_vault\_name          | Name of the AWS Backup Vault                | `string`       | `"production_backup_vault"` |    no    |
| backup\_plan\_name           | Name for the AWS Backup Plan                | `string`       | `"production_backup_plan"`  |    no    |
| kms\_key\_alias              | Alias for the KMS encryption key            | `string`       | `"backup_vault_key"`        |    no    |
| backup\_schedule\_expression | Backup schedule cron expression             | `string`       | `"cron(0 2 * * ? *)"`       |    no    |
| delete\_after\_days          | Retention period for backups                | `number`       | `35`                        |    no    |
| backup\_tag\_key             | Tag key for selecting resources to backup   | `string`       | `"Backup"`                  |    no    |
| backup\_tag\_value           | Tag value for selecting resources to backup | `string`       | `"Enabled"`                 |    no    |
| additional\_backup\_rules    | List of additional backup rules             | `list(object)` | `[]`                        |    no    |
| enable\_sns\_notifications   | Enable SNS notifications                    | `bool`         | `false`                     |    no    |
| sns\_topic\_arn              | ARN of SNS topic for notifications          | `string`       | `""`                        |    no    |
| tags                         | Common tags for resources                   | `map(string)`  | `{}`                        |    no    |

## Outputs

| Name               | Description                   |
| ------------------ | ----------------------------- |
| backup\_vault\_arn | ARN of the Backup Vault       |
| backup\_plan\_id   | ID of the AWS Backup Plan     |
| kms\_key\_arn      | ARN of the KMS encryption key |

## Best Practices

* Regularly review and test backup restoration processes.
* Ensure KMS key rotation is enabled for maximum security.
* Tag resources consistently to ensure comprehensive backups.

## License

This module is licensed under the MIT License. See `LICENSE` for more information.

## Maintainers

* Your Name – [youremail@example.com](mailto:youremail@example.com)

## Support

For issues, please open a GitHub issue or reach out directly to the maintainers.
