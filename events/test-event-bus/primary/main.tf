terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.63.0"
    }
  }

  backend "s3" {
    encrypt = true
    key     = "global/events/tesst-bus/euw2/terraform.tfstate"
    region  = "eu-west-2"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_event_bus" "podcast" {
  name = "test-message-bus"
  tags = {
    Name        = "test-message-bus"
    Description = "Event Bus for testing in euw2"
  }
}

#resource "aws_cloudwatch_event_archive" "podcast" {
#  description      = "Event Archive for the test-message-bus"
#  event_source_arn = aws_cloudwatch_event_bus.podcast.arn
#  name             = "test-message-bus-archive"
#  retention_days   = 30
#}
