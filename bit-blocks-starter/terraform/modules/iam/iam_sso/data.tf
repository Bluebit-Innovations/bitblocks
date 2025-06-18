data "aws_ssoadmin_instances" "this" {
    count = var.test_mode ? 0 : 1
}