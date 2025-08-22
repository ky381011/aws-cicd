resource "aws_vpc" "vpc"{
  cidr_block           = "172.16.0.0/20"
  enable_dns_hostnames = true
  tags = {
    Name = "tf_test"
  }
}