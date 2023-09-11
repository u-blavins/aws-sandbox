terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.63.0"
    }
  }

  backend "s3" {
    encrypt = true
    key     = "global/s3/serverless/euw2/terraform.tfstate"
    region  = "eu-west-2"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "serverless_bucket" {
  bucket = var.serverless_bucket_name

  tags = {
    Name        = var.serverless_bucket_name
    Description = "Bucket for storing package files for serverless lambdas"
  }
}

resource "aws_s3_bucket_versioning" "serverless_bucket" {
  bucket = aws_s3_bucket.serverless_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "serverless_bucket_lc_config" {
  bucket = aws_s3_bucket.serverless_bucket.id
  rule {
    id     = "expire-non-current-objects"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  bucket = aws_s3_bucket.serverless_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "serverless_bucket_access_block" {
  bucket = aws_s3_bucket.serverless_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "serverless_bucket_policy" {
  bucket = aws_s3_bucket.serverless_bucket.id
  policy = data.aws_iam_policy_document.serverless_bucket_policy_document.json
}

data "aws_iam_policy_document" "serverless_bucket_policy_document" {
  depends_on = [aws_s3_bucket.serverless_bucket]
  statement {
    sid = "allow-iam-users-access"
    principals {
      identifiers = var.iam_users
      type        = "AWS"
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.serverless_bucket.arn,
      "${aws_s3_bucket.serverless_bucket.arn}/*",
    ]
  }
}
