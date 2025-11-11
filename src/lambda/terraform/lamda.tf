resource "aws_lambda_function" "example" {
  filename         = var.package_file_name
  function_name    = var.function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "return_hash.lambda_handler"
  runtime         = "python3.13"
  environment {
    variables = {

    }
  }
  tags = {
    Name = "tf_test"
    deploy = "github_actions"
  }
}

resource "aws_lambda_function_url" "example" {
  function_name      = aws_lambda_function.example.function_name
  authorization_type = "NONE" # or "AWS_IAM"

  cors {
    allow_origins  = ["*"]
    allow_methods  = ["*"]
    allow_headers  = ["*"]
  }
}