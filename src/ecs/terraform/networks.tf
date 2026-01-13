# ================================
# VPC
# ================================

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_hostnames = var.vpc.enable_dns_hostnames
  tags                 = var.tags
}

# ================================
# Internet Gateway
# ================================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

# ================================
# Subnets
# ================================

resource "aws_subnet" "subnets" {
  for_each = var.subnet.cidrs

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value

  tags = var.tags
}

# ================================
# Route Table
# ================================

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.route_table.destination_cidr_block
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "subnet_associations" {
  for_each = var.subnet.cidrs

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public_rt.id
}

# ================================
# Network Interface (NIC)
# ================================

resource "aws_network_interface" "ec2_nic" {
  for_each = var.ec2.nics

  subnet_id       = aws_subnet.subnets[each.key].id
  private_ips     = each.value
  security_groups = [aws_security_group.ec2_sg.id]

  tags = var.tags
}

# ================================
# Security Group
# ================================

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = {
    for idx, rule in var.security_group.ingress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.ec2_sg.id

  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_ipv4   = each.value.cidr_blocks
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = {
    for idx, rule in var.security_group.egress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.ec2_sg.id

  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_ipv4   = each.value.cidr_blocks
}
