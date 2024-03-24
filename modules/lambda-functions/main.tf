locals {
  lambda_function_tools_path = "/home/comwork/cloud_practice/mini-lab-s3-lambda/modules/lambda-functions/src"
  lambda_layer_zip           = "python.zip"
}

data "archive_file" "zip_main" {
  type        = "zip"
  source_file = "${local.lambda_function_tools_path}/main.py"
  output_path = "${local.lambda_function_tools_path}/main.zip"
}

# data "archive_file" "zip_layer_one" {
#   type        = "zip"
#   source_dir  = "${local.lambda_function_tools_path}/lambda_layer/python"
#   output_path = "${local.lambda_function_tools_path}/${local.lambda_layer_zip}"
# }

# # Create a bucket to store the .zip used by the lambda layer
# resource "aws_s3_bucket" "bucket" {
#   bucket              = "aws-layer-file"
#   object_lock_enabled = true
# }


# #upload the .zip file to the bucket

# resource "aws_s3_bucket_object" "upload_zip" {
#   bucket = aws_s3_bucket.bucket.id # Replace with your bucket name
#   key    = local.lambda_layer_zip            # Specify the desired object key (file name)

#   # Path to your local CSV file
#   source = "${local.lambda_function_tools_path}/${local.lambda_layer_zip}"

# }



# resource "aws_lambda_layer_version" "pandas_lambda_layer" {
#   s3_bucket           = aws_s3_bucket.bucket.id
#   s3_key              = local.lambda_layer_zip
#   layer_name          = "my-pandas-layer"
#   compatible_runtimes = [var.lambda_runtime]
#   # source_code_hash    = filebase64("${local.lambda_function_tools_path}/${local.lambda_layer_zip}")
#   depends_on = [data.archive_file.zip_layer_one, aws_s3_bucket_object.upload_zip]

# }


resource "aws_lambda_function" "csv_processor" {
  function_name    = var.lambda_function_name
  runtime          = var.lambda_runtime
  handler          = "main.lambda_handler"
  role             = aws_iam_role.lambda_role.arn
  filename         = "${local.lambda_function_tools_path}/main.zip"
  source_code_hash = data.archive_file.zip_main.output_base64sha256
  layers           = var.lambda_layers
  timeout          = 60
  # Define environment variables
  environment {
    variables = {
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

resource "aws_iam_role_policy" "function_logging_policy" {
  name = "function-logging-policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Effect   = "Allow",
      Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

#Trigger the Lambda function when a new CSV file is uploaded to the source bucket
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }
}
