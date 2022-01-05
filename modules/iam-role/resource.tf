# @author: Syed Umair Ali
# @since: 30 December, 2021
# @description: Generic Terraform IAM Role Resource
# @license: All Rights Reserved to Raisin DS
# @Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.service_identifiers]
    }
  }
}

resource "aws_iam_role" "iam_role" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [aws_iam_policy.iam_policy.arn]
  tags = merge(
    var.common_tags,
    {
      Name          = var.name
    }
  )
}

resource "aws_iam_policy" "iam_policy" {
  name = var.policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_actions
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.enable_instance_profile ? 1 : 0
  name = var.profile_name
  role = aws_iam_role.iam_role.name
}
