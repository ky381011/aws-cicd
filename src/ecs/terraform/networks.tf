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
  subnet_id   = aws_subnet.subnets.id
  private_ips = var.ec2_nic_cidr

  tags = var.tags
}
