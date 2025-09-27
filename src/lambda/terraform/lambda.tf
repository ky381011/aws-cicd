resource "aws_vpc" "lambda"{
  cidr_block           = "192.168.0.0/24"
  enable_dns_hostnames = true
  tags = {
    Name = "lambda_test_vpc"
    deploy = "github_actions"
  }
}

resource "aws_subnet" "main" {
    vpc_id = aws_vpc.lambda.id
    cidr_block = "192.168.0.0/26"

    tags = {
        Name = "lambda_test_subnet"
        deploy = "github_actions"
    }
}
