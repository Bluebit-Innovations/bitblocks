resource "aws_flow_log" "vpc_flow_log" {
  count = var.enable_flow_logs ? 1 : 0

  log_destination      = var.flow_log_destination_type == "s3" ? aws_s3_bucket.flow_log_bucket[0].arn : aws_cloudwatch_log_group.flow_logs[0].arn
  log_destination_type = var.flow_log_destination_type
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  iam_role_arn         = var.flow_log_destination_type == "cloud-watch-logs" ? aws_iam_role.flow_log_role[0].arn : null
}

resource "aws_s3_bucket" "flow_log_bucket" {
  count = var.flow_log_destination_type == "s3" ? 1 : 0

  bucket = "${var.name_prefix}-flow-logs"
  force_destroy = true
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name              = "/vpc/${var.name_prefix}/flow-logs"
  retention_in_days = var.flow_log_retention_days
}

resource "aws_iam_role" "flow_log_role" {
  count = var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name = "${var.name_prefix}-flow-logs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "flow_logs_policy_attach" {
  count      = var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0
  role       = aws_iam_role.flow_log_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonVPCFlowLogsRole"
}

resource "aws_default_network_acl" "default_acl" {
  default_network_acl_id = var.default_network_acl_id

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = var.vpc_id

  revoke_rules_on_delete = true

  ingress = []
  egress = []
}

resource "aws_security_group_rule" "prevent_public_subnet_egress" {
  count = var.prevent_public_subnet_access ? 1 : 0

  security_group_id = aws_default_security_group.default_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Block default SG from accessing public internet"
}
