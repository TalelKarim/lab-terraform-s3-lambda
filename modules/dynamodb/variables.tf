variable "dynamodb_db_name" {
  type        = string
  description = "The name of the Dynamodb database that will be created"
}

variable "Environment" {
  type        = string
  description = "The environment of execution"
}