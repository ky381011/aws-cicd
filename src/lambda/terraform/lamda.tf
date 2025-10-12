resource "aws_lambda_function" "example" {
  filename         = var.package_file_name
  function_name    = "example_lambda"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python"
  environment {
    variables = {

    }
  }
  tags = {
    Name = "tf_test"
    deploy = "github_actions"
  }
}