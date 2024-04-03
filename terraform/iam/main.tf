# Create an IAM policy_iam_policy for the EC2 to access the secretsmanager
resource "aws_iam_policy" "secretsmanager_iam_policy" {
  name = var.secrets_iam_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
        ]
        Resource = "*"
      }
    ]
  })
}

# Create an IAM policy_iam_policy for the EC2 to access the ECR
resource "aws_iam_policy" "ecr_iam_policy" {
  name = var.ecr_iam_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "ecr:GetAuthorizationToken",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ecr:PutLifecyclePolicy",
          "ecr:PutImageTagMutability",
          "ecr:StartImageScan",
          "ecr:CreateRepository",
          "ecr:PutImageScanningConfiguration",
          "ecr:UploadLayerPart",
          "ecr:BatchDeleteImage",
          "ecr:DeleteLifecyclePolicy",
          "ecr:DeleteRepository",
          "ecr:PutImage",
          "ecr:CompleteLayerUpload",
          "ecr:StartLifecyclePolicyPreview",
          "ecr:InitiateLayerUpload",
          "ecr:DeleteRepositoryPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create the IAM role
resource "aws_iam_role" "service_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "secrets_role_policy_attachment" {
  name = "Policy Attachement"
  policy_arn = aws_iam_policy.secretsmanager_iam_policy.arn
  roles       = [aws_iam_role.service_role.name]
}

resource "aws_iam_policy_attachment" "ecr_role_policy_attachment" {
  name = "Policy Attachement"
  policy_arn = aws_iam_policy.ecr_iam_policy.arn
  roles       = [aws_iam_role.service_role.name]
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "service_instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.service_role.name
}

resource "aws_iam_user" "cicd_python_service" {    
  name = "cicd_python_service"
}

resource "aws_iam_user_policy" "AmazonEC2ContainerRegistryPowerUser" {  
  name = "AmazonEC2ContainerRegistryPowerUser"  
  user = aws_iam_user.cicd_python_service.name
  policy = <<EOF
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ],
        "Resource" : "*"
      }
    ]
  }
    EOF
}
