resource "aws_subnet" "subnet0" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.0.0/24"
  tags = {
    Name = "tf_test"
  }
}