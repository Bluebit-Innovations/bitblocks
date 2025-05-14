module "test_group_basic" {
    source = "../terraform-modules/iam/iam_group"

    for_each   = toset(local.group_names)
    group_name = title(each.value)
    group_path = "/user_groups/${each.value}/"

    tags = {
        Group-Name = each.value
    }
}
