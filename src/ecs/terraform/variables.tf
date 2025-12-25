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

# VPC
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

# Subnets
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

# NICs
variable "nic" {
  description = "Network interface configuration"
  type = object({
    ec2_cidrs = map(list(string))
  })
  default = {
    ec2_cidrs = {
      subnet0 = ["172.16.0.10"]
    }
  }
}

# Security Group
variable "security_group" {
  description = "Security group configuration"
  type = object({
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
  default = {
    ingress_rules = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

# ================================
# Compute Variables
# ================================
variable "ec2" {
  description = "Compute configuration"
  type = object({
    instance_type = string
  })
  default = {
    instance_type = "t3.micro"
  }
}

# ================================
# Authority Variables
# ================================
variable "authority" {
  description = "IAM authority configuration"
  type = object({
    instance_role_name   = string
    instance_policy_arn  = string
    profile_name         = string
  })
  default = {
    instance_role_name  = "ecs-instance-role"
    instance_policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    profile_name        = "ecs-instance-profile"
  }
}