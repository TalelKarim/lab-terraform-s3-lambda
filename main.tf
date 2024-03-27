provider "aws" {
}

module "s3_bucket" {
  source              = "./modules/s3-bucket"
  bucket_name         = "input-bucket-tk"
  target_function_arn = module.lambda_function.function_arn
}

module "lambda_function" {
  source               = "./modules/lambda-functions"
  lambda_function_name = var.lambda_function_name
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
  function_name = var.lambda_function_name
}

# module "EventBridge" {
#   source = "./modules/event-bridge"
#   target_lambda_function_arn = module.lambda_function.function_arn
#   source_bucket_name = module.s3_bucket.s3_bucket_name
# }

module "csv_uploader" {
  source          = "./modules/uploader"
  bucket_id       = module.s3_bucket.s3_bucket_name
  input_file_path = "./assets/file_to_upload.csv"
  csv_filename    = "input_file.csv"
  depends_on      = [module.lambda_function]

}

module "api_gataway" {
  source                     = "./modules/api-gateway"
  lambda_function_invoke_arn = module.lambda_function.invoke_arn
  lambda_function_name       = module.lambda_function.function_name
}