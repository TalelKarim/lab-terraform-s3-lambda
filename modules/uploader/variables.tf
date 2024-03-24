variable "csv_filename" {
  type        = string
  description = "The name of the file uploaded to the s3"
}

variable "input_file_path" {
  type        = string
  description = "The path of the file to be uploaded"
}

variable "bucket_id" {
  type        = string
  description = "The ID of the bucket where the file will be uploaded"
}