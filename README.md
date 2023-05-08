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

## Deploy

For deploying a resource, navigate to the resource, app and the region to deploy to. To ensure that no resource
names are committed to source control, each app and region has variable files set to dynamically populate the 
`main.tf` files. To set the variable values, create a file named `secret.tfvars` and `backend.hcl` to store the
variable values for the `main.tf` and for the backend configuration.

Worth stating for the example below, you will need to remove backend from the `main.tf` if the s3 bucket and 
dynamo db table has not been created. This allows for the bucket and table to be created for storing terraform
state files, and state locks.

```bash
$ cd s3/tf-state-bucket/primary
$ vim secret.tfvars
> terraform_bucket_name = test-state-bucket-euw2
> terraform_dynamo_table = tf-state-lock-table

$ vim backend.hcl
> terraform_bucket_name = test-state-bucket-euw2
> terraform_dynamo_table = tf-state-lock-table

$ terraform init -backend-config=backend.hcl
$ terraform plan -var-file=secret.tfvars
$ terraform apply -var-file=secret.tfvars
```
