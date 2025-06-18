output "permission_sets" {
  description = "Details of created permission sets"
  value = {
    for k, v in aws_ssoadmin_permission_set.this :
    k => {
      arn        = v.arn
      name       = v.name
      session    = v.session_duration
    }
  }
}
