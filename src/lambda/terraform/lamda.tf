resource "aws_lambda_function" "example" {
  filename         = var.package_file_name
  function_name    = var.function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "return_hash.lambda_handler"
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