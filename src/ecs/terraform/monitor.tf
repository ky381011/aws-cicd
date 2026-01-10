# ================================
# CloudWatch Dashboard
# ================================

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.cloudwatch.dashboard_name
  dashboard_body = replace(
    jsonencode(var.cloudwatch.dashboard_body),
    "$${instance_id}",
    aws_instance.ec2.id
  )
}