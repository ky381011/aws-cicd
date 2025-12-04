resource "aws_vpc" "vpc"{
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = var.tags
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet_cidrs

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value

  tags = var.tags
}

resource "aws_network_interface" "ec2_nic" {
  for_each = var.ec2_nic_cidrs

  subnet_id   = aws_subnet.subnets.id
  private_ips = each.value

  tags = var.tags
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
