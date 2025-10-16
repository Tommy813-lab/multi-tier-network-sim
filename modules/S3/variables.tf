variable "bucket_name" {
  description = "The name of the S3 bucket to create or reference"
  type        = string
  default     = "my-default-bucket-name"   # optional, remove if you want to force input
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3 and 63 characters."
  }
}
