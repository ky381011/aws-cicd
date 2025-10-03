terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {}

resource "aws_lambda_function" "example" {
  filename         = "lambda_function.zip"
  function_name    = "example_lambda"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
  environment {
    variables = {
      ENV = var.environment
    }
  }
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}