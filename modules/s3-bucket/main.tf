resource "aws_s3_bucket" "bucket" {
  bucket              = var.bucket_name
  object_lock_enabled = true

}


resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "file-transition"

    expiration {
      days = 90
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#upload the .csv file to the bucket

resource "aws_s3_bucket_object" "upload_csv" {
  bucket = aws_s3_bucket.bucket.id # Replace with your bucket name
  key    = var.csv_filename        # Specify the desired object key (file name)

  # Path to your local CSV file
  source = var.input_file_path

  # Calculate the MD5 hash of the file for ETag
  etag = filemd5(var.input_file_path)
}

#Add permission to allow invoking the lambda function 

# Create Lambda permission for S3 to invoke the Lambda function
resource "aws_lambda_permission" "s3_invoke_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.target_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}


