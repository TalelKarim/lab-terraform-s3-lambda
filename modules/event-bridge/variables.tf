variable "target_lambda_function_arn" {
  type        = string
  description = "The ARN of the target lambda function"
}

variable "source_bucket_name" {
  type        = string
  description = "The name of the source s3 bucket"
}