resource "aws_subnet" "subnet0" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.0.0/24"
  tags = {
    Name = "tf_test"
  }
}

resource "aws_subnet" "subnet4" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.4.0/24"
  tags = {
    Name = "tf_test"
  }
}

resource "aws_subnet" "subnet8" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.8.0/24"
  tags = {
    Name = "tf_test"
  }
}

resource "aws_subnet" "subnet12" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.12.0/24"
  tags = {
    Name = "tf_test"
  }
}