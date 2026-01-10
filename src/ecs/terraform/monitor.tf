# ================================
# CloudWatch Dashboard
# ================================

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.cloudwatch.dashboard_name
  dashboard_body = jsonencode(var.cloudwatch.dashboard_body)
}