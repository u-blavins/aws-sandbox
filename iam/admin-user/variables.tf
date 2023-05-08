variable "aws_region" {
  description = "Region to deploy AWS resources to"
  type        = string
  default     = "eu-west-2"
}

variable "iam_group_name" {
  description = "Name given for an IAM group"
  type        = string
}

variable "iam_path" {
  description = "Path prefix for an IAM resource"
  type        = string
}

variable "iam_user_name" {
  description = "Name given for an IAM user"
  type        = string
}
