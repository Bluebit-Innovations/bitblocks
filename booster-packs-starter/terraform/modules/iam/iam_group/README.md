# IAM Group Module

 This module creates and manages AWS IAM groups with associated policies and
 memberships. It includes comprehensive IAM management features including:

### Core IAM Components:
 - IAM Group creation with customizable name and path
 - Group membership management
 - Inline policy attachments
 - Managed policy attachments

### SSO Integration:
 - AWS SSO permission set creation and management
 - Account assignments for SSO users/groups
 - SSO instance data retrieval

### Security & Compliance:
 - IAM Access Analyzer integration for security assessment
 - CloudTrail logging for IAM activity monitoring
 - Service Control Policies (SCPs) for environment-specific restrictions


## Core Features:
 - Flexible group naming and path structure
 - Multiple policy attachment support (both inline and managed)
 - Dynamic user membership management
 - Environment-specific security controls
 - Comprehensive audit logging


## Example

```hcl
module "iam_group" {
        source = "./terraform-modules/iam/iam_group"
        
        providers = {
            aws.primary   = aws.primary
            aws.secondary = aws.secondary
        }

        # Group name
        group_name = "developers"
        
        # Attach AWS managed and custom policies
        policy_arns = [
                "arn:aws:iam::aws:policy/ReadOnlyAccess",
                "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
                "arn:aws:iam::123456789012:policy/CustomPolicy"
        ]

        # Optional: Associate users with the group
        user_names = [
                "developer1",
                "developer2",
                "developer3"
        ]
}
```


## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| group_name | The name of the IAM group | `string` | n/a | yes |
| group_description | Description of the IAM group | `string` | n/a | yes |
| group_users | List of IAM users to add to the group | `list(string)` | n/a | yes |
| group_path | The path of the IAM group | `string` | `"/"` | no |
| inline_policies | List of inline policies to attach to the group | `list(string)` | `[]` | no |
| managed_policy_arns | List of managed policy ARNs to attach to the group | `list(string)` | `[]` | no |
| account_assignments | List of account assignments for the group | `map(object({`<br>`permission_set_arn = string`<br>`principal_id = string`<br>`principal_type = string`<br>`account_id = string`<br>`}))` | `{}` | no |
| permission_sets | List of permission sets for the group | `map(object({`<br>`description = string`<br>`session_duration = number`<br>`}))` | `{}` | no |
| enable_sso | Flag to enable/disable SSO resources | `bool` | `true` | no |
| enable_access_analyzer | Flag to enable/disable IAM Access Analyzer | `bool` | `false` | no |
| enable_cloudtrail | Flag to enable/disable CloudTrail monitoring | `bool` | `false` | no |
| cloudtrail_bucket_name | Name of the S3 bucket for CloudTrail logs | `string` | n/a | yes |
| enable_scp | Flag to enable/disable Service Control Policies | `bool` | `false` | no |
| environment | Environment name (prod, staging, dev) | `string` | n/a | yes |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam_group_arn | The ARN of the IAM group |
| iam_group_name | The name of the IAM group |
| iam_group_id | The ID of the IAM group |
| iam_group_users | The list of IAM users in the IAM group |
| iam_group_path | The path of the IAM group |
| iam_group_policy_attachments | The list of IAM policy attachments to the IAM group |
| iam_group_membership | The list of IAM group memberships |
| iam_group_inline_policies | The list of IAM inline policies to the IAM group |
| iam_group_managed_policies | The list of IAM managed policies to the IAM group |
| access_analyzer_id | The ID of the Access Analyzer |
| cloudtrail_arn | The ARN of the CloudTrail |
| cloudtrail_name | The name of the CloudTrail |
| scp_id | The ID of the Service Control Policy |
| scp_arn | The ARN of the Service Control Policy |


# Usage:
 - Define group name, path, and users
 - Specify inline policies and managed policy ARNs
 - Configure SSO settings if required
 - Enable security features like Access Analyzer and CloudTrail

#### Note: This module supports both standard IAM group management and 
#### AWS SSO integration, providing a comprehensive identity management solution.

## Notes
- The module creates a single IAM group
- Multiple IAM policies can be attached to the group
- Users can be added to the group during creation
- Ensure you have necessary permissions to create IAM resources
- Creates permission sets in AWS SSO with specified configurations
- Associates permission sets with users/groups for specific AWS accounts
- Enable CloudTrail for IAM monitoring
- Service control policies for environment-specific restrictions 
