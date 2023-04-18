# aws-sandbox

Repository for playing around with multiple different AWS services, as well as potentially deploying lightweight 
application on said cloud services.

## Prerequisites

- Terraform
- AWS CLI
- AWS Account

## New AWS Account Setup

- Switch `Payment Currency Preference` to `GBP` from `USD`
- Enable `Activate IAM Access` to allow IAM entities to be able to look at billing
- Enable `MFA` for Root User
- Generate Access Keys for Root Account (Delete afterwards, required for setting up initial IAM Users/Groups)
- Install `aws` on local device, then enter `aws configure` to link AWS Account to local device
