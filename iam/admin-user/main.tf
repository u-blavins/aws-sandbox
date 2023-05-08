terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.63.0"
    }
  }

  backend "s3" {
    key     = "global/iam/admin-user/euw2/terraform.tfstate"
    encrypt = true
    region  = "eu-west-2"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

# create aws iam group for administrators
resource "aws_iam_group" "admins" {
  name = var.iam_group_name
  path = var.iam_path
}

# reference iam policy for admin access - using aws managed policy
data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

# create iam group policy attachment to grant group permissions
resource "aws_iam_group_policy_attachment" "admins" {
  group      = aws_iam_group.admins.name
  policy_arn = data.aws_iam_policy.admin_access.arn
}

# create iam admin user
resource "aws_iam_user" "admin_user" {
  name = var.iam_user_name
  path = var.iam_path
}

# attach admin user to admin group
resource "aws_iam_user_group_membership" "admin_group" {
  user   = aws_iam_user.admin_user.name
  groups = [aws_iam_group.admins.name]
}

# create user login profile
resource "aws_iam_user_login_profile" "admin_user" {
  user                    = aws_iam_user.admin_user.name
  password_reset_required = true
}

resource "aws_iam_access_key" "admin_user" {
  user = aws_iam_user.admin_user.name
  status = "Active"
}

output "password" {
  value = aws_iam_user_login_profile.admin_user.password
  sensitive = true
}

output "secret" {
  value = aws_iam_access_key.admin_user.secret
  sensitive = true
}
