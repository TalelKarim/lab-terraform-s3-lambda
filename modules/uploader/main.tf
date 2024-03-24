
#upload the .csv file to the bucket

resource "aws_s3_bucket_object" "upload_csv" {
  bucket = var.bucket_id    # Replace with your bucket name
  key    = var.csv_filename # Specify the desired object key (file name)

  # Path to your local CSV file
  source = var.input_file_path

  # Calculate the MD5 hash of the file for ETag
  etag = filemd5(var.input_file_path)
}
