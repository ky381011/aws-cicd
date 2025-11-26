resource "aws_vpc" "vpc"{
  cidr_block           = "172.16.0.0/20"
  enable_dns_hostnames = true
  tags = {
    Name = "tf_test"
    deploy = "github_actions"
  }
}

variable "subnet_cidrs" {
  default = {
    subnet0  = "172.16.0.0/24"
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet_cidrs

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value

  tags = {
    Name = "tf_test"
    deploy = "github_actions"
  }
}
