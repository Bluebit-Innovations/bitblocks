module "test_group_advanced" {
    source = "../../iam_group"

    for_each = toset(local.group_names)

    group_name             = title(each.value)
    group_path             = "/user_groups/${each.value}/"
    group_description      = "${each.value} group"
    group_users            = lookup(local.group_users_map, each.value, [])
    enable_managed_policies = true
    enable_inline_policies  = false
    managed_policy_arns    = lookup(
        { for group in local.group_managed_policies : group.group_name => group.managed_policy_arns },
        each.value,
        []
    )


    tags = {
        Group-Name = each.value
    }
}