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

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = {
    for idx, rule in var.sg_ingress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.ec2_sg.id

  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_blocks = each.value.cidr_blocks
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = {
    for idx, rule in var.sg_egress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.ec2_sg.id

  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_blocks = each.value.cidr_blocks
}
