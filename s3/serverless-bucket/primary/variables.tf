variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "serverless_bucket_name" {
  description = "Bucket name for storing serverless packages to"
  type        = string
}

variable "iam_users" {
  description = "List of IAM users to grant access to the bucket"
  type        = list(string)
}
