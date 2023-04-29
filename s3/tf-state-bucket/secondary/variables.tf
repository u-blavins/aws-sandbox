variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "terraform_bucket_name" {
  description = "Bucket for storing Terraform files to"
  type        = string
}

variable "terraform_dynamo_table" {
  description = "Dynamo DB table for storing terraform locks"
  type        = string
}
