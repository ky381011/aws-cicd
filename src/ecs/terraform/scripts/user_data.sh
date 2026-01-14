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

# Create directory for static website content
mkdir -p /var/www/html

# Create sample static website files
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ECS Static Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
        }
        .info {
            background-color: #e7f3ff;
            padding: 15px;
            border-left: 4px solid #007bff;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>ECS Static Website with Volume Mount</h1>
        <p>このWebサイトはECSのボリュームマウント機能を使用してデプロイされています。</p>
        
        <div class="info">
            <strong>構成情報:</strong>
            <ul>
                <li>Webサーバー: Nginx</li>
                <li>ホストパス: /var/www/html</li>
                <li>コンテナパス: /usr/share/nginx/html</li>
                <li>ポート: 8080</li>
            </ul>
        </div>
        
        <p>このHTMLファイルはEC2インスタンスの /var/www/html に配置され、Nginxコンテナにマウントされています。</p>
    </div>
</body>
</html>
EOF

cat > /var/www/html/about.html << 'EOF'
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About - ECS Static Website</title>
</head>
<body>
    <h1>About This Website</h1>
    <p>This is a static website deployed using ECS with volume mounts.</p>
    <a href="index.html">Back to Home</a>
</body>
</html>
EOF

# Set permissions for static website files
chmod -R 755 /var/www/html

# Start ECS agent (already installed on ECS-optimized AMI)
systemctl enable --now ecs
