provider "aws" {
}


module "s3_bucket" {
  source          = "./modules/s3-bucket"
  bucket_name     = "input-bucket-tk"
  input_file_path = "./assets/file_to_upload.csv"
}

module "lambda_function" {
  source               = "./modules/lambda-functions"
  labmda_function_name = "csv_processor"
  lambda_runtime       = "python3.10"
  bucket_name          = module.s3_bucket.s3_bucket_name
  dynamodb_arn         = module.dynamodb.dynamodb_table_arn
  dynamodb_table_name  = module.dynamodb.dynamodb_table_name
}

module "dynamodb" {
  source           = "./modules/dynamodb"
  dynamodb_db_name = "Gaming"
  Environment      = "dev"
}