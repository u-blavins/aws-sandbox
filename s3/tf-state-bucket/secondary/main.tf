terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.63.0"
    }
  }

  backend "s3" {
    bucket         = "BUCKET_NAME"
    key            = "global/tf-backend/euw1/terraform.tfstate"
    region         = "eu-west-1"

    dynamodb_table = "tf-state-lock-table"
    encrypt        = true
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "BUCKET_NAME"
  tags = {
    "Name" = "BUCKET_NAME"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "tf-state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags = {
    "Name" = "tf-state-lock-table"
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }
}
