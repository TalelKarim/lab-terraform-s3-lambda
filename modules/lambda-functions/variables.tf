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

variable "lambda_layers" {
  type        = list(string)
  description = "The layers managed by AWS to be uploaded for the lambda function"
  default     = ["arn:aws:lambda:eu-west-3:336392948345:layer:AWSSDKPandas-Python38:18"]
}