output "function_name" {
  value = aws_lambda_function.csv_processor.function_name
}

output "function_arn" {
  value = aws_lambda_function.csv_processor.arn
}

output "invoke_arn" {
  value = aws_lambda_function.csv_processor.invoke_arn
}