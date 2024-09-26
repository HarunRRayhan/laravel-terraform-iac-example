variable "domain_name" {
  description = "Domain name for the SSL certificate"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}