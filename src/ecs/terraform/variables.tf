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
    root_volume = object({
      type                  = string
      size                  = number
      delete_on_termination = bool
      encrypted             = bool
    })
  })
  default = {
    instance_type = "t3.micro"
    root_volume = {
      type                  = "gp3"
      size                  = 30
      delete_on_termination = true
      encrypted             = true
    }
  }
}

# ================================
# Authority Variables
# ================================
variable "authority" {
  description = "IAM role and policy configuration for ECS instances"
  type = object({
    instance_role_name = string
    profile_name       = string
    policy_arns = object({
      ecs_service = string
      ssm_core    = string
    })
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