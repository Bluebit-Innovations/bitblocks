output "config_recorder_name" {
  value = aws_config_configuration_recorder.this.name
}

output "conformance_pack_status" {
  value = try(aws_config_conformance_pack.this[0].name, "")
  description = "Name of the deployed conformance pack"
}
