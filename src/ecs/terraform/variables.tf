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
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "172.16.0.0/20"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
  default     = true
}

# Subnets
variable "subnet_cidrs" {
  type        = map(string)
  description = "Map of subnet names to CIDR blocks"
  default = {
    subnet0 = "172.16.0.0/24"
  }
}

# NICs
variable "ec2_nic_cidrs" {
  type        = map(list(string))
  description = "Map of NIC names to private IP addresses (must match subnet_cidrs keys)"
  default = {
    subnet0 = ["172.16.0.10"]
  }
}

# Security Group Rules
variable "sg_ingress_rules" {
  description = "Ingress rules for the EC2 SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
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
}

variable "sg_egress_rules" {
  description = "Egress rules for the EC2 SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# ================================
# Compute Variables
# ================================
variable "instance_type" {
  default = "t3.micro"
}

# ================================
# Authority Variables
# ================================
variable "ecs_instance_role_name" {
  default = "ecs-instance-role"
}

variable "ecs_instance_policy_arn" {
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

variable "ecs_profile_name" {
  default = "ecs-instance-profile"
}