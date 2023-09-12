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

resource "aws_cloudwatch_event_rule" "podcast" {
  description    = "Log Events to CloudWatch"
  event_bus_name = aws_cloudwatch_event_bus.podcast.arn
  is_enabled     = true
  name           = "test-message-bus-event-logger-rule"
  event_pattern  = jsonencode({
    account = ["903771974408"]
  })

  tags = {
    Name        = "test-message-bus-event-logger-rule"
    Description = "Log Events to CloudWatch"
  }
}

resource "aws_cloudwatch_event_target" "podcast_logging" {
  arn            = aws_cloudwatch_log_group.podcast_log_group.arn
  rule           = aws_cloudwatch_event_rule.podcast.name
  event_bus_name = aws_cloudwatch_event_bus.podcast.arn
  target_id      = "TestBusEventsLogGroup"
}

resource "aws_cloudwatch_log_group" "podcast_log_group" {
  name              = "/aws/events/podcast/test"
  retention_in_days = 30

  tags = {
    Name        = "/aws/events/podcast/test"
    Description = "Cloud Watch Log Group for test-bus Events"
  }
}

resource "aws_cloudwatch_event_archive" "podcast" {
  description      = "Event Archive for the test-message-bus"
  event_source_arn = aws_cloudwatch_event_bus.podcast.arn
  name             = "test-message-bus-archive"
  retention_days   = 30
}
