# Create EventBridge rule to trigger Lambda when object is added to the bucket
resource "aws_cloudwatch_event_rule" "s3_event_rule" {
  name = "s3_object_added_rule"
  event_pattern = jsonencode({
    source      = ["aws.s3"],
    detail_type = ["AWS API Call via CloudTrail"],
    detail = {
      eventSource = ["s3.amazonaws.com"],
      eventName   = ["PutObject"]
      requestParameters = {
        bucketName = [var.source_bucket_name],
      }
    }
  })
}

# Create Lambda target for EventBridge rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.s3_event_rule.name
  arn  = var.target_lambda_function_arn
}