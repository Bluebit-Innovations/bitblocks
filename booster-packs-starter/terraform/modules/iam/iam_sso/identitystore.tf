#########################
# OPTIONAL: INTERNAL IDENTITY USERS/GROUPS
#########################

resource "aws_identitystore_user" "example_user" {
  for_each = var.identity_source_type == "AWS" ? var.users : {}
  identity_store_id = data.aws_ssoadmin_instances.main.identity_store_ids[0]
  user_name         = each.value.user_name
  display_name      = each.value.display_name
  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }
  emails {
    value    = each.value.email_value
    primary  = each.value.email_primary
    type     = each.value.email_type
  }
}

resource "aws_identitystore_group" "example_group" {
  for_each = var.enable_group_creation ? local.groups_to_create : {}

  identity_store_id = data.aws_ssoadmin_instances.main.identity_store_ids[0]
  display_name      = each.value.name
  description       = each.value.description
}
