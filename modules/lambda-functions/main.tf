locals {
  lambda_function_tools_path = "/home/comwork/cloud_practice/mini-lab-s3-lambda/modules/lambda-functions/src"
}

data "archive_file" "zip_main" {
  type        = "zip"
  source_file = "${local.lambda_function_tools_path}/main.py"
  output_path = "${local.lambda_function_tools_path}/main.zip"
}

data "archive_file" "zip_layer_one" {
  type        = "zip"
  source_dir  = "${local.lambda_function_tools_path}/lambda_layer/python"
  output_path = "${local.lambda_function_tools_path}/python.zip"
}

resource "aws_lambda_layer_version" "pandas_layer" {
  filename            = "${local.lambda_function_tools_path}/python.zip" # Update with the correct path
  layer_name          = "my-python-pandas-layer"
  compatible_runtimes = [var.lambda_runtime]
  # source_code_hash    = filebase64("${local.lambda_function_tools_path}/python.zip")
  depends_on          = [data.archive_file.zip_layer_one]
}


resource "aws_lambda_function" "csv_processor" {
  function_name    = var.labmda_function_name
  runtime          = var.lambda_runtime
  handler          = "main.lambda_handler"
  role             = aws_iam_role.lambda_role.arn
  filename         = "/home/comwork/cloud_practice/mini-lab-s3-lambda/modules/lambda-functions/src/main.zip"
  source_code_hash = data.archive_file.zip_main.output_base64sha256
  layers           = [aws_lambda_layer_version.pandas_layer.arn]
  # Define environment variables
  environment {
    variables = {
      BUCKET_NAME         = var.bucket_name
      FILE_KEY            = "input_csv_file"
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_access" {
  name = "s3_access_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:PutObject"
      ],
      Effect   = "Allow",
      Resource = "arn:aws:s3:::${var.bucket_name}/*"
    }]
  })
}
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "dynamodb_access_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ],
      Effect   = "Allow",
      Resource = var.dynamodb_arn
    }]
  })

}
# # Trigger the Lambda function when a new CSV file is uploaded to the source bucket
# resource "aws_s3_bucket_notification" "lambda_trigger" {
#   bucket = var.bucket_name

#   lambda_function {
#     lambda_function_arn = aws_lambda_function.csv_processor.arn
#     events              = ["s3:ObjectCreated:*"]
#     filter_suffix       = ".csv"
#   }
# }
