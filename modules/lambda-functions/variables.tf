variable "labmda_function_name" {
  type        = string
  description = "The name of the lambda function that will be created"
}

variable "lambda_runtime" {
  type        = string
  description = "the runtime to be used by the lambda function"
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket that the lambda function will retrieve data from"
}

variable "dynamodb_arn" {
  type        = string
  description = "The Arn of the dynamod database where lambda function will put data"
}

variable "dynamodb_table_name" {
  type        = string
  description = "The name of the dynamodb table"
}