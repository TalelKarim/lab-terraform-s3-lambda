variable "bucket_name" {
  type        = string
  description = "The name of the created bucket"
}

variable "target_function_arn" {
  type        = string
  description = "The name of the function that will be invoked"
}
