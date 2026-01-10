# ================================
# CloudWatch Dashboard
# ================================

resource "aws_cloudwatch_dashboard" "main" {
  count = var.cloudwatch.dashboard_body != "" ? 1 : 0

  dashboard_name = var.cloudwatch.dashboard_name
  dashboard_body = var.cloudwatch.dashboard_body
}