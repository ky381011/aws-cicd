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
variable "vpc_cidr" {
  default = "172.16.0.0/20"
}

variable "subnet_cidrs" {
  default = {
    subnet0 = "172.16.0.0/24"
  }
}

variable "ec2_nic_cidrs" {
  default = {
    nic0 = "172.16.0.10"
  }
}

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

# Root Volume Configuration
variable "root_volume_type" {
  description = "Root volume type (gp2, gp3, io1, io2)"
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  default     = 30
}

variable "root_volume_delete_on_termination" {
  description = "Delete root volume on instance termination"
  default     = true
}

variable "root_volume_encrypted" {
  description = "Enable root volume encryption"
  default     = true
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