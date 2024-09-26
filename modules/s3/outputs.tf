output "bucket_regional_domain_name" {
  value = aws_s3_bucket.main.bucket_regional_domain_name
}

output "bucket_name" {
  value = aws_s3_bucket.main.id
}