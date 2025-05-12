# Local variables
locals {
    flattened_policies = flatten([
        for name, config in var.permission_sets : [
            for policy_arn in config.managed_policies : {
                name       = name
                policy_arn = policy_arn
            }
        ]
    ])

valid_environments = ["dev", "staging", "prod"]
    environment = contains(local.valid_environments, var.environment) ? var.environment : "dev"
    
    default_tags = merge({
        Environment = local.environment
        ManagedBy   = "terraform"
        Module      = "iam-group"
    }, var.tags)

    # Define environment-specific restrictions
    prod_restrictions    = [
        "sso:DeletePermissionSet",
        "sso:DeleteAccountAssignment",
        "sso:DeleteManagedApplicationInstance"
    ]
    staging_restrictions = [
        "sso:DeletePermissionSet",
        "sso:DeleteAccountAssignment"
    ]
    dev_restrictions    = [
        "sso:DeletePermissionSet"
    ]

    # Environment-specific restrictions
    restrictions = concat(
        var.environment == "prod" ? local.prod_restrictions : [],
        var.environment == "staging" ? local.staging_restrictions : [],
        var.environment == "dev" ? local.dev_restrictions : []
    )

}