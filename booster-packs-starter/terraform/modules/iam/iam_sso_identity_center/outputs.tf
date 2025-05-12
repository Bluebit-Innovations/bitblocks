# output "sso_group_arn" {
#   description = "The ARN of the SSO group"
#   value       = aws_ssoadmin_group.this.arn
# }


# Outputs
output "permission_set_arns" {
    description = "ARNs of the created permission sets"
    value = {
        for name, permission_set in aws_ssoadmin_permission_set.this : name => permission_set.arn
    }
}

output "managed_policy_attachment_arns" {
    description = "ARNs of the created managed policy attachments"
    value = {
        for name, managed_policy_attachment in aws_ssoadmin_managed_policy_attachment.this : name => managed_policy_attachment.arn
    }
}

output "account_assignment_ids" {
    description = "IDs of the created account assignments"
    value = {
        for name, account_assignment in aws_ssoadmin_account_assignment.this : name => account_assignment.id
    }
}

output "instance_arn" {
    description = "ARN of the SSO instance"
    value = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

