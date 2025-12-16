# For EC2 instance
resource "aws_iam_role" "ecs_instance_role" {
  name = var.ecs_instance_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = var.ecs_instance_policy_arn
}

resource "aws_iam_instance_profile" "ecs_profile" {
  name = var.ecs_profile_name
  role = aws_iam_role.ecs_instance_role.name
}