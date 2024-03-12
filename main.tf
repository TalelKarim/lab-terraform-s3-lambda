provider "aws" {
}


module "s3_bucket" {
  source          = "./modules/s3-bucket"
  bucket_name     = "input-bucket-tk"
  input_file_path = "./assets/file_to_upload.csv"
}

module "lambda_function" {
  source               = "./modules/lambda-functions"
  labmda_function_name = var.labmda_function_name
  lambda_runtime       = "python3.8"
  bucket_name          = module.s3_bucket.s3_bucket_name
  dynamodb_arn         = module.dynamodb.dynamodb_table_arn
  dynamodb_table_name  = module.dynamodb.dynamodb_table_name
}

module "dynamodb" {
  source           = "./modules/dynamodb"
  dynamodb_db_name = "Friends"
  Environment      = "dev"
}

module "cloudwatch" {
  source        = "./modules/cloudwatch"
  function_name = var.labmda_function_name
}