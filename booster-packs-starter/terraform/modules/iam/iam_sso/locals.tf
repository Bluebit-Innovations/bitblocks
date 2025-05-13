# Local variables
locals {
    # flattened_policies = flatten([
    #     for name, config in var.permission_sets : [
    #         for policy_arn in config.managed_policies : {
    #             name       = name
    #             policy_arn = policy_arn
    #         }
    #     ]
    # ])


valid_environments = ["dev", "staging", "prod", "global"]
    environment = contains(local.valid_environments, var.environment) ? var.environment : "dev"
    
    default_tags = merge({
        Environment = local.environment
        ManagedBy   = "terraform"
        Module      = "iam-group"
    }, var.tags)

    # Define environment-specific restrictions
    global_restrictions    = [
        "sso:DeletePermissionSet",
        "sso:DeleteAccountAssignment",
        "sso:DeleteManagedApplicationInstance"
    ]

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

    groups = yamldecode(file(var.group_config_file))

  # Filter valid groups that have an ID (for assignments only)
  valid_groups = [
    for group in local.groups.groups : group
    if (
      length(trimspace(group.id)) > 0 &&
      can(regex("^([0-9a-f]{10}-|)[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}$", group.id))
    )
  ]


#Create SSO assignments for groups
  sso_assignments = flatten([
    for group in local.valid_groups : [
      for account_id in group.account_ids : {
        target_type    = "GROUP"
        target_id      = group.id
          permission_set = {
            name           = group.permission_set
            managed_policies = lookup(var.permission_sets, group.permission_set, [])
          }
        account_id     = account_id
      }
    ]
  ])

  # Groups that should be created
  groups_to_create = {
    for group in local.groups.groups : group.name => group
    if length(trimspace(group.id)) == 0
  }


}