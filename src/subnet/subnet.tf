variable "subnet_cidrs" {
  default = {
    subnet0  = "172.16.0.0/24"
    subnet4  = "172.16.4.0/24"
    subnet8  = "172.16.8.0/24"
    subnet12 = "172.16.12.0/24"
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet_cidrs

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value

  tags = {
    Name = "tf_test"
  }
}
