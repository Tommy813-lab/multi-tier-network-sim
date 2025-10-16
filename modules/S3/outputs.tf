output "s3_bucket_info" {
  value = {
    name             = aws_s3_bucket.this.bucket
    arn              = aws_s3_bucket.this.arn
    region           = aws_s3_bucket.this.region
    website_endpoint = aws_s3_bucket.this.website_endpoint
  }
  description = "Information about the S3 bucket"
}
