resource "aws_ssm_patch_baseline" "this" {
  name             = var.patch_baseline_name
  approved_patches = var.approved_patches
  operating_system = var.operating_system
  approval_rule {
    approve_after_days = var.approve_after_days
    compliance_level   = var.compliance_level
    enable_non_security = var.enable_non_security
    patch_filter {
      key    = "CLASSIFICATION"
      values = var.patch_classifications
    }
    patch_filter {
      key    = "SEVERITY"
      values = var.patch_severities
    }
  }

  tags = var.tags
}

resource "aws_ssm_document" "baseline_config" {
  name          = var.config_doc_name
  document_type = "Command"
  content       = file("${var.config_doc_file}")
}

resource "aws_ssm_association" "patching" {
  name             = "PatchingAssociation-${aws_ssm_document.baseline_config.name}"
  document_version = "$LATEST"
  targets {
    key    = "InstanceIds"
    values = var.instance_ids
  }
  schedule_expression = var.patching_cron
  compliance_severity = "HIGH"
  automation_target_parameter_name = "InstanceId"
}

resource "aws_ssm_association" "secure_config" {
  name             = "SecureConfigAssociation-${aws_ssm_document.baseline_config.name}"
  document_version = "$LATEST"
  targets {
    key    = "InstanceIds"
    values = var.instance_ids
  }
}
