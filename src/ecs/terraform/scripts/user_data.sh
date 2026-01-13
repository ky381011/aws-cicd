#!/bin/bash

# ECS設定ファイルにクラスター名を書き込む
echo "ECS_CLUSTER=${cluster_name}" >> ${ecs_config_path}

# ECSエージェントを起動（ECS最適化AMIでは既にインストール済み）
systemctl enable --now ecs
