
#########################
# PERMISSION SETS
#########################


resource "aws_ssoadmin_permission_set" "this" {
  for_each = { for ps in var.permission_sets : ps.name => ps }

  name             = each.value.name
  description      = lookup(each.value, "description", "")
  instance_arn     = data.aws_ssoadmin_instances.main.arns[0]
  session_duration = "PT1H"

}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = { for ps in var.permission_sets : ps.name => ps }

  instance_arn       = data.aws_ssoadmin_instances.main.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  managed_policy_arn = each.value.policy_arn
}