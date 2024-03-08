resource "aws_dynamodb_table" "game-dynamodb-table" {
  name           = var.dynamodb_db_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "GameNumber"
  range_key      = "GameLength"

  attribute {
    name = "GameNumber"
    type = "N"
  }

  attribute {
    name = "GameLength"
    type = "N"
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = var.Environment
  }
}