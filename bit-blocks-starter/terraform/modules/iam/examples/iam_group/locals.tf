locals {
    group_names = ["administrators", "development", "cloud"]

    group_users_map = {
        administrators = ["Oreoluwa"]
        development    = ["Alice", "Bob"]
        cloud          = ["Charlie", "Dave"]
    }

    group_managed_policies_map = {
        administrators = ["arn:aws:iam::aws:policy/AdministratorAccess"]
        development    = []
        cloud          = []
    }

# Not in use currently, but can be uncommented if needed
    # group_users = [
    #     for name in local.group_names : {
    #         group_name = name
    #         users      = lookup(local.group_users_map, name, [])
    #     }
    # ]

    group_managed_policies = [
        for name in local.group_names : {
            group_name          = name
            managed_policy_arns = lookup(local.group_managed_policies_map, name, [])
        }
    ]
}



# module "groups_test" {
#     source = "../terraform-modules/iam/iam_group"

#     for_each = toset(local.group_names)

#     group_name             = title(each.value)
#     group_path             = "/user_groups/${each.value}/"
#     group_description      = "${each.value} group"
#     group_users            = lookup(local.group_users_map, each.value, [])
#     enable_managed_policies = true
#     enable_inline_policies  = false
#     managed_policy_arns    = lookup(
#         { for group in local.group_managed_policies : group.group_name => group.managed_policy_arns },
#         each.value,
#         []
#     )
#     environment            = "global"
#     enable_access_analyzer = false
#     enable_scp             = false
#     enable_cloudtrail      = false
#     cloudtrail_bucket_name = ""

#     tags = {
#         Group-Name = each.value
#     }
# }