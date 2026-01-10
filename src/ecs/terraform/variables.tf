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
  })
  default = {
    instance_type = "t3.micro"
    ami = {
      name_filter         = "al2023-ami-*-x86_64"
      virtualization_type = "hvm"
      owner_id            = "137112412989" # Amazon
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
  }
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
# Monitor Variables
# ================================
variable "cloudwatch" {
  description = "CloudWatch dashboard configuration"
  type = object({
    dashboard_name = string
    dashboard_body = object({
      widgets = list(object({
        type = string
        properties = object({
          metrics = optional(list(list(string)))
          period  = optional(number)
          stat    = optional(string)
          region  = optional(string)
          title   = optional(string)
          yAxis = optional(object({
            left = optional(object({
              min = optional(number)
              max = optional(number)
            }))
          }))
        })
      }))
    })
  })
  default = {
    dashboard_name = "ecs-instance-dashboard"
    dashboard_body = {
      widgets = []
    }
  }
}