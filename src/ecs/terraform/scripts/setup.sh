#!/bin/bash

sudo yum update -y
sudo yum install -y git
sudo yum install -y docker

sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

sudo mkdir -p /usr/local/lib/docker/cli-plugins

VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
      | grep tag_name \
      | cut -d '"' -f 4)

echo "Latest Docker Compose version: $VER"

sudo curl -L \
  https://github.com/docker/compose/releases/download/${VER}/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

sudo ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose
