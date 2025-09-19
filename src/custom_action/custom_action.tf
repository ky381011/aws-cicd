resource "aws_vpc" "test_state"{
  cidr_block           = "172.16.0.0/20"
  enable_dns_hostnames = true
  tags = {
    Name = "tf_test"
    deploy = "github_actions"
  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.test_state.id
  cidr_block              = "172.16.0.0/24"
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name   = "tf_test-subnet"
    deploy = "github_actions"
  }
}