resource "aws_vpc" "test_vpc"{
  cidr_block           = "172.16.0.0/20"
  enable_dns_hostnames = true
  tags = {
    Name = "tf_test"
  }
}