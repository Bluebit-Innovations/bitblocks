locals {
  flattened_policy_attachments = {
    for tuple in flatten([
      for ps_name, ps_data in var.permission_sets : [
        for policy_arn in ps_data.managed_policies : {
          key                = "${ps_name}-${replace(basename(policy_arn), "/", "-")}"
          permission_set_name = ps_name
          policy_arn          = policy_arn
        }
      ]
    ]) : tuple.key => {
      permission_set_name = tuple.permission_set_name
      policy_arn          = tuple.policy_arn
    }
  }
}
