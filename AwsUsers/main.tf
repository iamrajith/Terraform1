variable "myregion" {
  description = "Your required aws region"
}

variable "myaccesskey" {
  description = "Your IAM access key"
}

variable "mysecretkey" {
    description = "Your SEC key"
  
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
  access_key = var.myaccesskey
  secret_key = var.mysecretkey
}

variable "userscount" {
default = 5
}

resource "aws_iam_user" "myusers" {
  count = var.userscount
  name = "testuser${count.index}"
  tags = {
    Name = "testuser${count.index}"
  }
}

###   For_Each type of looping

variable "userlist" {
type = list
default = ["vikas","nidhi","deepak"]
}

resource "aws_iam_user" "iamusers" {
  for_each = toset(var.userlist)
  name = each.value
  tags = {
    Name = each.value
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = "vikas"
  roles      = [aws_iam_role.role.name]
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}