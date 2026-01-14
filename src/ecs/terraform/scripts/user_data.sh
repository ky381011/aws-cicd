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

# Install git if not already installed
if ! command -v git &> /dev/null; then
    yum install -y git
fi

# Create directory for static website content
mkdir -p /var/www/html

# Clone repository and copy static files
cd /tmp
git clone -b ${git_branch} ${git_repo_url} repo-temp
if [ -d "repo-temp/src/ecs/static" ]; then
    cp -r repo-temp/src/ecs/static/* /var/www/html/
    echo "Static files deployed from GitHub repository"
else
    echo "Static files directory not found, creating default files"
    cat > /var/www/html/index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ECS Static Website</title>
</head>
<body>
    <h1>ECS Static Website</h1>
    <p>Deployed from GitHub repository</p>
</body>
</html>
HTMLEOF
fi

# Cleanup
rm -rf /tmp/repo-temp

# Set permissions for static website files
chmod -R 755 /var/www/html

# Start ECS agent (already installed on ECS-optimized AMI)
systemctl enable --now ecs
