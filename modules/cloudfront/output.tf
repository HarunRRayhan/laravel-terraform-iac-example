output "distribution_id" {
  value = aws_cloudfront_distribution.main.id
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "origin_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
}