# ================================
# CloudWatch Dashboard
# ================================

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.cloudwatch.dashboard_name
  dashboard_body = jsonencode({
    widgets = jsondecode(replace(
      file(var.cloudwatch.widgets_file),
      "$${instance_id}",
      aws_instance.ec2.id
    ))
  })
}