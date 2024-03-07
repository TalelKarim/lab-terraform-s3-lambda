provider "aws" {
}


module "s3_buket" {
  source          = "./modules/s3-bucket"
  bucket_name     = "input-bucket-tk"
  input_file_path = "./assets/file_to_upload.csv"
}