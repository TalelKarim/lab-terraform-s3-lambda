resource "aws_dynamodb_table" "friends-dynamodb-table" {
  name           = var.dynamodb_db_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"
  range_key      = "name"
  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "Subject"
    type = "S"
  }

  global_secondary_index {
    name               = "Subject"
    hash_key           = "name"
    range_key          = "Subject"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["id"]
  }
  tags = {
    Name        = "dynamodb-table-1"
    Environment = var.Environment
  }
}