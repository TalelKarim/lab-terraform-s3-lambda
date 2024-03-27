resource "aws_api_gateway_rest_api" "csvAPI" {
  name        = "csvAPI"
  description = "API Gateway for triggering Lambda function"
}


resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.csvAPI.id
  parent_id   = aws_api_gateway_rest_api.csvAPI.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.csvAPI.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "LambdaIntegration" {
  rest_api_id = aws_api_gateway_rest_api.csvAPI.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn
}

resource "aws_api_gateway_deployment" "CsvDeployment" {
  depends_on = [aws_api_gateway_integration.LambdaIntegration]

  rest_api_id = aws_api_gateway_rest_api.csvAPI.id
  stage_name  = "test"
}

resource "aws_lambda_permission" "AllowAPIGatewayInvoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # Ensure the source ARN is restricted to your API Gateway
  source_arn = "${aws_api_gateway_rest_api.csvAPI.execution_arn}/*/*/*"
}
