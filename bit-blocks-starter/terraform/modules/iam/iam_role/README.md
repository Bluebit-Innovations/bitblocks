



# Module: AWS IAM Role Management with Enhanced Security Controls

 This module creates and manages AWS IAM roles with comprehensive security features including:
 
 - Core IAM role creation with customizable assume role policies
 - Policy attachment support for multiple IAM policies
 - IAM Access Analyzer for security assessment
 - CloudTrail integration for comprehensive IAM activity monitoring
 - Environment-specific service control policies (SCP)
 
## Key Features:
 - Flexible role configuration
 - Multi-policy attachment support
 - Automated security analysis
 - Audit logging capability
 - Environment-based access restrictions

## Usage

```hcl
module "iam_role" {
    source = "./terraform-modules/iam/iam_role"
    
    role_name = "example-role"
    description = "Example IAM role"
    
    # Trust relationship policy
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    # List of policy ARNs to attach
    policy_arns = [
        "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    ]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| role_name | Name of the IAM role | string | yes |
| description | Description of the IAM role | string | no |
| assume_role_policy | JSON policy document for trust relationship | string | yes |
| policy_arns | List of policy ARNs to attach to role | list(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| iam_role_arn | The ARN of the IAM role |
| iam_role_name | The name of the IAM role |
| iam_role_unique_id | The unique ID assigned by AWS for the IAM role |
| iam_role_policy_arns | The ARNs of the IAM role policies |
| iam_role_policy_names | The names of the IAM role policies |
| iam_role_policy_ids | The IDs of the IAM role policies |
| iam_role_policy_attachments | The IAM role policy attachments |
| iam_role_policy_attachments_count | The count of IAM role policy attachments |
| iam_role_policy_attachments_arns | The ARNs of the IAM role policy attachments |
| iam_role_policy_attachments_roles | The roles of the IAM role policy attachments |
| iam_role_policy_attachments_policy_arns | The policy ARNs of the IAM role policy attachments |
| iam_role_policy_attachments_policy_names | The policy names of the IAM role policy attachments |
| iam_role_policy_attachments_policy_ids | The policy IDs of the IAM role policy attachments |
| iam_role_policy_attachments_policy_arns_count | The count of policy ARNs of the IAM role policy attachments |
| iam_role_policy_attachments_policy_names_count | The count of policy names of the IAM role policy attachments |
| iam_role_policy_attachments_policy_ids_count | The count of policy IDs of the IAM role policy attachments |
| iam_role_policy_attachments_arns_count | The count of ARNs of the IAM role policy attachments |
| iam_role_policy_attachments_roles_count | The count of roles of the IAM role policy attachments |
| iam_role_policy_attachments_ids_count | The count of IDs of the IAM role policy attachments |
