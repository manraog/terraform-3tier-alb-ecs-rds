resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.amazonaws.com"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_policy_document" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "ssm:GetParameters",
    ]

    resources = ["*"]
  }
}

# create iam policy
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name   = "ecs-policy-${var.project}-${var.environment}"
  policy = data.aws_iam_policy_document.ecs_task_execution_policy_document.json
}

# create an iam role
resource "aws_iam_role" "ecs_task_execution_role" {
  name                = "ecs-role-${var.project}-${var.environment}"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
}

# attach ecs task execution policy to the iam role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

# create iam task role
data "aws_iam_policy_document" "ecs_task_role_policy_document" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]
  }
}

# create iam policy
resource "aws_iam_policy" "ecs_task_role_policy" {
  name   = "ecs-role-policy-${var.project}-${var.environment}"
  policy = data.aws_iam_policy_document.ecs_task_role_policy_document.json
}

# create an iam role
resource "aws_iam_role" "ecs_task_role" {
  name                = "ecs-task-role-${var.project}-${var.environment}"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
}

# attach ecs task execution policy to the iam role
resource "aws_iam_role_policy_attachment" "ecs_task_role_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}