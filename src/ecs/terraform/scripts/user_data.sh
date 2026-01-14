#!/bin/bash

# Write cluster name to ECS config file
echo "ECS_CLUSTER=${cluster_name}" >> ${ecs_config_path}

# Create directory for Nginx configuration files
mkdir -p /etc/ecs-config/nginx

# Create Nginx configuration file
cat > /etc/ecs-config/nginx/default.conf << 'EOF'
server {
    listen 80;
    server_name _;

    # Access logs
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Root location
    location / {
        return 200 '<html><head><title>ECS on EC2</title></head><body><h1>Hello from ECS on EC2!</h1><p>Nginx is running successfully.</p></body></html>';
        add_header Content-Type text/html;
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF

# Set permissions
chmod 644 /etc/ecs-config/nginx/default.conf

# Start ECS agent (already installed on ECS-optimized AMI)
systemctl enable --now ecs
