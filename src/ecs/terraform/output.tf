# ================================
# EC2 Instance Outputs
# ================================

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2.private_ip
  sensitive   = true
}

output "ec2_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.ec2.private_dns
  sensitive   = true
}

# ================================
# Nginx Access Information
# ================================

output "nginx_proxy_port" {
  description = "Port number for Nginx Proxy (public access point)"
  value       = 80
}

output "nginx_access_info" {
  description = "Nginx access information (accessible from within private network via proxy only)"
  value = {
    private_ip    = aws_instance.ec2.private_ip
    proxy_port    = 80
    proxy_url     = "http://${aws_instance.ec2.private_ip}"
  }
  sensitive = true
}

# ================================
# ECS Cluster Information
# ================================

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
  sensitive   = true
}

# ================================
# SSM Session Manager Access
# ================================

output "ec2_instance_id" {
  description = "EC2 instance ID (for SSM port forwarding)"
  value       = aws_instance.ec2.id
  sensitive   = true
}

output "ssm_port_forward_command" {
  description = "Command to use SSM Session Manager for port forwarding to Nginx Proxy"
  value       = "aws ssm start-session --target ${aws_instance.ec2.id} --document-name AWS-StartPortForwardingSession --parameters \"portNumber=80,localPortNumber=8080\""
  sensitive   = true
}

output "ssm_access_instructions" {
  description = "Instructions to access Nginx via SSM"
  value = <<-EOT
    1. Install AWS CLI and Session Manager Plugin
       - AWS CLI: https://aws.amazon.com/cli/
       - Session Manager Plugin: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
    
    2. Access Nginx Proxy (port 80):
       aws ssm start-session --target <INSTANCE_ID> --document-name AWS-StartPortForwardingSession --parameters "portNumber=80,localPortNumber=8080"
       Open http://localhost:8080 in your browser
    
    Note: 
    - Replace <INSTANCE_ID> with the actual EC2 instance ID from terraform output (use 'terraform output ec2_instance_id' to retrieve it)
    - All web traffic should go through the proxy on port 80. Direct access to backend services is not exposed.
  EOT
}
