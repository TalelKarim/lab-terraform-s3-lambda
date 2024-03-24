variable "bucket_name" {
  type        = string
  description = "The name of the created bucket"
}

variable "input_file_path" {
  type        = string
  description = "The path to the csv file to upload"
}

variable "target_function_arn" {
  type        = string
  description = "The name of the function that will be invoked"
}

variable "csv_filename" {
  type        = string
  description = "Name of the file uploaded in s3"
} 