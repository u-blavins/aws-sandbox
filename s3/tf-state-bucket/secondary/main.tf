terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.63.0"
    }
  }

  backend "s3" {
    key            = "global/tf-backend/euw1/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.terraform_bucket_name
  tags = {
    "Name" = var.terraform_bucket_name
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

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lc_config" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    id     = "expire-non-current-objects-and-delete"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 10
    }
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = var.terraform_dynamo_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags = {
    "Name" = var.terraform_dynamo_table
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }
}
