# ================================
# Common Variables
# ================================
variable "tags" {
  default = {
    Name   = "tf_test"
    deploy = "github_actions"
  }
}

# ================================
# Network Variables
# ================================
variable "vpc" {
  description = "VPC configuration"
  type = object({
    cidr_block           = string
    enable_dns_hostnames = bool
  })
  default = {
    cidr_block           = "172.16.0.0/20"
    enable_dns_hostnames = true
  }
}

variable "subnet" {
  description = "Subnet configuration"
  type = object({
    cidrs = map(string)
  })
  default = {
    cidrs = {
      subnet0 = "172.16.0.0/24"
    }
  }
}

variable "route_table" {
  description = "Route table configuration"
  type = object({
    name                   = string
    destination_cidr_block = string
  })
  default = {
    name                   = "public-route-table"
    destination_cidr_block = "0.0.0.0/0"
  }
}

variable "internet_gateway" {
  description = "Internet Gateway configuration"
  type = object({
    name = string
  })
  default = {
    name = "main-igw"
  }
}

variable "security_group" {
  description = "Security group configuration"
  type = object({
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = string
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = string
    }))
  })

  default = {
    ingress_rules = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = "0.0.0.0/0"
      }
    ]
  }
}

# ================================
# Compute Variables
# ================================
variable "ec2" {
  description = "EC2 instance configuration"
  type = object({
    instance_type = string
    ami = object({
      name_filter         = string
      virtualization_type = string
      owner_id            = string
    })
    root_volume = object({
      type                  = string
      size                  = number
      delete_on_termination = bool
      encrypted             = bool
    })
    nics = map(list(string))
    user_data = object({
      ecs_config_path = string
      git_repo_url    = string
      git_branch      = string
    })
  })
  default = {
    instance_type = "t3.micro"
    ami = {
      name_filter         = "al2023-ami-ecs-hvm-*-x86_64"
      virtualization_type = "hvm"
      owner_id            = "591542846629" # Amazon ECS-optimized AMI
    }
    root_volume = {
      type                  = "gp3"
      size                  = 30
      delete_on_termination = true
      encrypted             = true
    }
    nics = {
      subnet0 = ["172.16.0.10"]
    }
    user_data = {
      ecs_config_path = "/etc/ecs/ecs.config"
      git_repo_url    = "https://github.com/YOUR_USERNAME/aws-cicd.git"
      git_branch      = "main"
    }
  }
}

# --------------------------------
# User Data Override Variables
# --------------------------------
variable "ec2_user_data_git_repo_url" {
  description = "Git repository URL for user data script"
  type        = string
  default     = ""
}

variable "ec2_user_data_git_branch" {
  description = "Git branch for user data script"
  type        = string
  default     = ""
}

# ================================
# SSH Key Variables
# ================================
variable "ssh_key" {
  description = "SSH key pair configuration"
  type = object({
    name       = string
    public_key = string
  })
  default = {
    name       = "ec2-key"
    public_key = ""
  }
  sensitive = true
}

# ================================
# Authority Variables
# ================================
variable "authority" {
  description = "IAM role and policy configuration for ECS instances"
  type = object({
    instance_role_name = string
    profile_name       = string
    policy_arns        = map(string)
  })
  default = {
    instance_role_name = "ecs-instance-role"
    profile_name       = "ecs-instance-profile"
    policy_arns = {
      ecs_service = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
      ssm_core    = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }
}

# ================================
# ECS Variables
# ================================
variable "ecs" {
  description = "ECS cluster and services configuration"
  type = object({
    cluster = object({
      name               = string
      container_insights = string
    })
    task_definitions = map(object({
      family                   = string
      network_mode             = string
      requires_compatibilities = list(string)
      cpu                      = string
      memory                   = string
      container_name           = string
      container_image          = string
      container_cpu            = number
      container_memory         = number
      container_port           = number
      host_port                = number
      protocol                 = string
      volumes = list(object({
        name      = string
        host_path = string
      }))
      mount_points = list(object({
        source_volume  = string
        container_path = string
        read_only      = bool
      }))
    }))
    services = map(object({
      task_key      = string
      desired_count = number
      launch_type   = string
    }))
  })
  default = {
    cluster = {
      name               = "ecs-cluster"
      container_insights = "disabled" # disabled to stay within free tier
    }
    task_definitions = {
      proxy = {
        family                   = "nginx-task"
        network_mode             = "bridge"
        requires_compatibilities = ["EC2"]
        cpu                      = "128"
        memory                   = "256"
        container_name           = "nginx"
        container_image          = "nginx:latest"
        container_cpu            = 128
        container_memory         = 256
        container_port           = 80
        host_port                = 80
        protocol                 = "tcp"
        volumes = [{
          name      = "nginx-config"
          host_path = "/etc/ecs-config/nginx"
        }]
        mount_points = [{
          source_volume  = "nginx-config"
          container_path = "/etc/nginx/conf.d"
          read_only      = true
        }]
      }
      web = {
        family                   = "nginx-website-task"
        network_mode             = "bridge"
        requires_compatibilities = ["EC2"]
        cpu                      = "128"
        memory                   = "256"
        container_name           = "nginx-website"
        container_image          = "nginx:latest"
        container_cpu            = 128
        container_memory         = 256
        container_port           = 80
        host_port                = 8080
        protocol                 = "tcp"
        volumes = [{
          name      = "static-website"
          host_path = "/var/www/html"
        }]
        mount_points = [{
          source_volume  = "static-website"
          container_path = "/usr/share/nginx/html"
          read_only      = false
        }]
      }
    }
    services = {
      proxy = {
        task_key      = "proxy"
        desired_count = 1
        launch_type   = "EC2"
      }
      web = {
        task_key      = "web"
        desired_count = 1
        launch_type   = "EC2"
      }
    }
  }
}

# ================================
# Monitor Variables
# ================================
variable "cloudwatch" {
  description = "CloudWatch dashboard configuration"
  type = object({
    dashboard_name      = string
    widgets_file        = string
  })
  default = {
    dashboard_name = "ecs-instance-dashboard"
    widgets_file   = "./settings/widgets.json"
  }
}