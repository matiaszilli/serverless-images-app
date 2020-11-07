provider "aws" {
  region  = "us-east-1"
  version = "2.53.0"
}

locals {
  # Environment
  env = "PRO"
}

####################
# API
####################
module "api_gw" {
  source = "./modules/api_gateway"

  name       = "apigw-${local.env}"
  stage_name = "v1"
  path_part  = "{image+}"
  functions = [
    {
      method     = "POST"
      lambda_arn = module.lambda_upload.invoke_arn
    },
    {
      method     = "PUT"
      lambda_arn = module.lambda_update.invoke_arn
    }
  ]
}

####################
# LAMBDA
####################
module "lambda_upload" {
  source = "./modules/lambda"

  name                  = "uploadData-${local.env}"
  s3_bucket             = module.bucket_functions.id
  s3_key                = "files.zip"
  memory                = 128
  runtime               = "nodejs12.x"
  handler               = "src/upload/upload.handler"
  timeout               = 3
  apigw_execution_arn   = module.api_gw.execution_arn
  log_retention_in_days = 14
  environment = {
    AWS_NODEJS_CONNECTION_REUSE_ENABLED = 1
    S3_BUCKET_NAME                      = module.bucket_images.id
    DYNAMO_TABLE_NAME                   = module.dynamo_table.id
  }

  lambda_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "${module.dynamo_table.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::${module.bucket_images.id}",
                "arn:aws:s3:::${module.bucket_images.id}/*"
            ]
        }
    ]
}
POLICY
}

module "lambda_update" {
  source = "./modules/lambda"

  name                  = "updateData-${local.env}"
  s3_bucket             = module.bucket_functions.id
  s3_key                = "files.zip"
  memory                = 128
  runtime               = "nodejs12.x"
  handler               = "src/update/update.handler"
  timeout               = 3
  apigw_execution_arn   = module.api_gw.execution_arn
  log_retention_in_days = 14
  environment = {
    AWS_NODEJS_CONNECTION_REUSE_ENABLED = 1
    S3_BUCKET_NAME                      = module.bucket_images.id
    DYNAMO_TABLE_NAME                   = module.dynamo_table.id
  }

  lambda_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:Query",
                "dynamodb:PutItem"
            ],
            "Resource": "${module.dynamo_table.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::${module.bucket_images.id}",
                "arn:aws:s3:::${module.bucket_images.id}/*"
            ]
        }
    ]
}
POLICY
}

####################
# DYNAMO
####################
module "dynamo_table" {
  source = "./modules/dynamo"

  name           = "images_meta-${local.env}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"
  range_key      = "Version"
}

####################
# S3 IMAGES BUCKET
####################
module "bucket_images" {
  source = "./modules/s3"

  # Origin bucket params
  name = "exampawsimagesrepo-${lower(local.env)}"

  curr_obj_expiration    = 30
  noncurr_obj_expiration = 30
  policy                 = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::exampawsimagesrepo-${lower(local.env)}/*"
        }
    ]
}
POLICY

  # Replication bucket params
  name_replication = "exampawsimagesrepobackup-${lower(local.env)}"

  lifecycle_enabled                  = true
  replication_curr_obj_expiration    = 30
  replication_noncurr_obj_expiration = 30

}

####################
# S3 FUNCTIONS BUCKET
####################
module "bucket_functions" {
  source = "./modules/s3"

  # Origin bucket params
  name = "exampawsfunctionsrepo-${lower(local.env)}"

  lifecycle_enabled = false

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::exampawsfunctionsrepo-${lower(local.env)}/*"
        }
    ]
}
POLICY

}

####################
# S3 UPLOAD FUNCTION FILES
####################

module "upload_s3_file" {
  source = "./modules/s3_upload"

  bucket_name = module.bucket_functions.id
  s3_key      = "files.zip"
  file_source = "./code/files.zip"
}
