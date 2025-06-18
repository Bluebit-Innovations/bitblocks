locals {
  filtered_scps = [
    for scp in var.scp_policies : merge(scp, {
      policy_content = try(
        scp.use_policy_file == true && can(file("${path.module}/${scp.policy_file_path}")) 
          ? jsondecode(file("${path.module}/${scp.policy_file_path}")) 
          : jsondecode(scp.policy_inline),
        {}
      )
    }) if scp.enabled
  ]

  scps = {
    for scp in local.filtered_scps : scp.name => scp
  }
}

