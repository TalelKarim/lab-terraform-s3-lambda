# Output the bucket name
output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

# Output the bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.id
}