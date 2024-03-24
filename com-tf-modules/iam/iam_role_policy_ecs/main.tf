locals {
    account_id = data.aws_caller_identity.current.account_id
}
data "aws_caller_identity" "current" {}
# # ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
 }

 # ECS task execution role
resource "aws_iam_role" "global_ecs_task_execution_role" {
  name               = "${var.project}-ECSTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
  tags = var.common_tags
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "global_ecs_execution_role" {
  role       = aws_iam_role.global_ecs_task_execution_role.name
  policy_arn = aws_iam_policy.global_execution_policy.arn
}

resource "aws_iam_policy" "global_execution_policy" {
  name        = "${var.project}-ecs-execution-policy"
  description = "A ${var.project} Ecs policy"

  policy = jsonencode(
  {
   Version = "2012-10-17",
    Statement = [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ssm:*",
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
                "ecs:ExecuteCommand"
            ],
            "Resource": "*"
        }
    ]
  }
  )
}