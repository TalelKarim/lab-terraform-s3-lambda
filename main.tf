provider "aws" {   
}


module "s3_buket"{
    source = "./modules/s3-bucket"
    bucket_name = "input_bucket"
}