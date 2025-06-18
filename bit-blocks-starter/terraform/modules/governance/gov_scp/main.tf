resource "aws_organizations_policy" "scp" {
  for_each = local.scps

  name        = each.value.name
  description = each.value.description
  content     = jsonencode(each.value.policy_content)
  type        = "SERVICE_CONTROL_POLICY"
  tags        = each.value.tags
}


resource "aws_organizations_policy_attachment" "attachments" {
  for_each = {
    for pair in flatten([
      for scp_name, scp in local.scps : [
        for target in scp.target_ids : {
          key         = "${scp_name}-${target}"
          policy_id   = aws_organizations_policy.scp[scp_name].id
          target_id   = target
          environment = scp.environment
        }
      ]
    ]) : pair.key => pair
    if contains(var.allowed_environments, pair.environment)
  }

  policy_id = each.value.policy_id
  target_id = each.value.target_id
}


