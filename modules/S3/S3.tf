# ============================================================================
# AWS S3 Bucket - Production-Ready Configuration
# ============================================================================
# Description: Secure S3 bucket with encryption, versioning, and access controls
# Author: Charles Bucher
# Project: Multi-Tier AWS Infrastructure
# Security: Encrypted, private, versioned, with access logging
# Compliance: PCI-DSS, HIPAA, SOC 2 ready
# ============================================================================

# ============================================================================
# MAIN S3 BUCKET
# ============================================================================

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  # Bucket naming rules:
  # - 3-63 characters
  # - Lowercase letters, numbers, hyphens only
  # - Must be globally unique across ALL AWS accounts
  # - Cannot contain underscores or uppercase
  # - Cannot be formatted as IP address
  # Example: "myapp-prod-data-us-east-1-123456789012"

  force_destroy = var.force_destroy
  # WARNING: If true, deletes all objects when bucket is destroyed
  # Production: false (protect against accidental data loss)
  # Development: true (easier cleanup)

  # Tags for cost tracking and organization
  tags = merge(
    var.tags,
    {
      Name        = var.bucket_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "Storage"
      Service     = "S3"
      Purpose     = var.bucket_purpose
      Encryption  = "AES256"
      Versioned   = "true"
    }
  )

  # Lifecycle management
  lifecycle {
    prevent_destroy = var.environment == "prod" ? true : false
    # Prevent accidental deletion of production buckets
  }
}

# ============================================================================
# BUCKET OWNERSHIP CONTROLS
# ============================================================================

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
    # BucketOwnerEnforced: Disables ACLs, bucket owner owns all objects
    # BucketOwnerPreferred: Bucket owner owns objects if uploader sets bucket-owner-full-control ACL
    # ObjectWriter: Object uploader owns the object (legacy, not recommended)
  }

  # BucketOwnerEnforced is recommended for:
  # - Simplified access control (IAM policies only, no ACLs)
  # - Security best practices
  # - Easier management
}

# ============================================================================
# BLOCK PUBLIC ACCESS (CRITICAL FOR SECURITY)
# ============================================================================

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # SECURITY: All four settings should be true for private buckets
  # This prevents:
  # - Accidental public ACLs
  # - Bucket policies that grant public access
  # - Public access to buckets with public ACLs
  # - Cross-account access except via policies

  # Only set to false if you NEED a public bucket (rare)
  # For public websites, use CloudFront + OAI instead
}

# ============================================================================
# VERSIONING (CRITICAL FOR DATA PROTECTION)
# ============================================================================

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
    # Enabled: Keep multiple versions of objects
    # Suspended: Stop creating new versions (existing versions remain)
    # Note: Once enabled, versioning cannot be disabled, only suspended

    # MFA Delete (optional, for extra protection)
    # mfa_delete = var.mfa_delete_enabled ? "Enabled" : "Disabled"
    # Requires MFA to delete object versions or change versioning state
  }

  # Benefits of versioning:
  # - Protect against accidental deletion
  # - Recover from application failures
  # - Maintain audit trail of changes
  # - Required for compliance (SOC 2, etc.)

  # Cost consideration:
  # - Each version counts toward storage costs
  # - Use lifecycle rules to delete old versions
}

# ============================================================================
# SERVER-SIDE ENCRYPTION (REQUIRED FOR COMPLIANCE)
# ============================================================================

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_id != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_id
      # AES256: AWS-managed keys (SSE-S3) - Free, simple
      # aws:kms: Customer-managed keys (SSE-KMS) - More control, audit trail
    }

    bucket_key_enabled = var.kms_key_id != null ? true : false
    # Reduces KMS API calls by ~99% when using KMS encryption
    # Lowers costs significantly for high-request workloads
  }

  # COMPLIANCE: Encryption at rest is required for:
  # - PCI-DSS
  # - HIPAA
  # - SOC 2
  # - Most corporate security policies

  # SSE-KMS benefits:
  # - Audit trail in CloudTrail
  # - Key rotation
  # - Fine-grained access control
  # - Required for regulated data
}

# ============================================================================
# ACCESS LOGGING (SECURITY & COMPLIANCE)
# ============================================================================

resource "aws_s3_bucket_logging" "this" {
  count = var.logging_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix != null ? var.logging_target_prefix : "${var.bucket_name}/logs/"

  # Logs include:
  # - Bucket owner
  # - Request time
  # - Requester
  # - Operation
  # - Key
  # - HTTP status
  # - Error code

  # Use cases:
  # - Security auditing
  # - Access pattern analysis
  # - Compliance reporting
  # - Cost optimization (identify frequently accessed objects)

  # IMPORTANT: Target bucket must:
  # 1. Be in the same region
  # 2. Have ACLs enabled (object_ownership = "BucketOwnerPreferred")
  # 3. Grant log-delivery-write permission to AWS Log Delivery group
}

# ============================================================================
# LIFECYCLE RULES (COST OPTIMIZATION)
# ============================================================================

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.lifecycle_rules_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  # Rule 1: Transition old objects to cheaper storage
  rule {
    id     = "transition-to-intelligent-tiering"
    status = "Enabled"

    filter {
      prefix = var.lifecycle_rule_prefix != null ? var.lifecycle_rule_prefix : ""
      # Apply to all objects if prefix is empty
      # Or specify prefix like "logs/" to only affect certain objects
    }

    transition {
      days          = 30
      storage_class = "INTELLIGENT_TIERING"
      # Automatically moves objects between frequent/infrequent access
      # Cost: $0.0025 per 1000 objects monitored per month
      # Savings: Up to 70% on storage costs
    }

    transition {
      days          = 90
      storage_class = "GLACIER_IR"
      # Glacier Instant Retrieval
      # 68% cheaper than S3 Standard
      # Millisecond retrieval
      # Good for: Backups, archives accessed quarterly
    }

    transition {
      days          = 180
      storage_class = "GLACIER_FLEXIBLE_RETRIEVAL"
      # 82% cheaper than S3 Standard
      # Retrieval: Minutes to hours
      # Good for: Long-term archives, compliance data
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
      # 95% cheaper than S3 Standard
      # Retrieval: 12-48 hours
      # Good for: 7-10 year retention requirements
    }
  }

  # Rule 2: Delete old versions to save costs
  rule {
    id     = "delete-old-versions"
    status = var.versioning_enabled ? "Enabled" : "Disabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
      # Delete versions older than X days
      # Recommended: 30-90 days depending on recovery needs
    }

    # Optional: Transition old versions to cheaper storage first
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER_IR"
    }
  }

  # Rule 3: Delete incomplete multipart uploads
  rule {
    id     = "delete-incomplete-multipart-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
      # Clean up failed uploads after 7 days
      # Prevents wasted storage costs from abandoned uploads
    }
  }

  # Rule 4: Expire objects after certain time (if applicable)
  rule {
    id     = "expire-old-objects"
    status = var.object_expiration_enabled ? "Enabled" : "Disabled"

    filter {
      prefix = var.object_expiration_prefix != null ? var.object_expiration_prefix : ""
    }

    expiration {
      days = var.object_expiration_days
      # Permanently delete objects after X days
      # Good for: Temporary files, logs with retention policies
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

# ============================================================================
# CORS CONFIGURATION (if bucket is accessed from web browsers)
# ============================================================================

resource "aws_s3_bucket_cors_configuration" "this" {
  count = var.cors_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

  # Example for web application:
  # allowed_methods = ["GET", "PUT", "POST"]
  # allowed_origins = ["https://example.com"]
  # allowed_headers = ["*"]
}

# ============================================================================
# BUCKET POLICY (IAM-based access control)
# ============================================================================

resource "aws_s3_bucket_policy" "this" {
  count = var.bucket_policy_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  policy = var.custom_bucket_policy != null ? var.custom_bucket_policy : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnforceTLSRequestsOnly"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = ["AES256", "aws:kms"]
          }
        }
      }
    ]
  })

  # Security policies enforce:
  # 1. TLS/HTTPS only (no plain HTTP)
  # 2. Encrypted uploads only
  # 3. (Add more as needed: IP restrictions, VPC endpoint only, etc.)

  depends_on = [aws_s3_bucket_public_access_block.this]
}

# ============================================================================
# REPLICATION CONFIGURATION (Disaster Recovery - Optional)
# ============================================================================

resource "aws_s3_bucket_replication_configuration" "this" {
  count = var.replication_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id
  role   = var.replication_role_arn

  rule {
    id     = "replicate-all-objects"
    status = "Enabled"

    filter {}

    destination {
      bucket        = var.replication_destination_bucket_arn
      storage_class = var.replication_storage_class

      # Optional: Encrypt replica with different KMS key
      encryption_configuration {
        replica_kms_key_id = var.replication_kms_key_id
      }

      # Optional: Replicate to different AWS account
      # account = var.replication_destination_account_id

      # Optional: Replication Time Control (15-minute SLA)
      # replication_time {
      #   status = "Enabled"
      #   time {
      #     minutes = 15
      #   }
      # }
    }

    # Optional: Delete marker replication
    delete_marker_replication {
      status = "Enabled"
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
  # Replication requires versioning to be enabled
}

# ============================================================================
# INTELLIGENT-TIERING ARCHIVE CONFIGURATION
# ============================================================================

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count = var.intelligent_tiering_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id
  name   = "EntireBucket"

  # Archive objects not accessed for 90 days
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  # Deep archive objects not accessed for 180 days
  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }

  # Optional: Apply only to objects with specific tags
  # filter {
  #   prefix = "documents/"
  #   tags = {
  #     Archive = "true"
  #   }
  # }
}

# ============================================================================
# OBJECT LOCK (Compliance Mode - WORM)
# ============================================================================

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = var.object_lock_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode = var.object_lock_mode
      # COMPLIANCE: Cannot be deleted by anyone, including root
      # GOVERNANCE: Can be deleted by users with special permission

      days  = var.object_lock_retention_days
      # years = var.object_lock_retention_years
    }
  }

  # Object Lock use cases:
  # - Regulatory compliance (SEC, FINRA)
  # - Legal hold
  # - Data immutability requirements
  # - Ransomware protection

  # IMPORTANT: Object Lock can only be enabled at bucket creation
  # Must set object_lock_enabled = true in aws_s3_bucket resource
}

# ============================================================================
# CLOUDWATCH METRICS & ALARMS
# ============================================================================

resource "aws_cloudwatch_metric_alarm" "bucket_size" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.bucket_name}-large-bucket-size"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = "86400" # 24 hours
  statistic           = "Average"
  threshold           = var.bucket_size_alarm_threshold
  alarm_description   = "Bucket size exceeded threshold"
  alarm_actions       = var.sns_alarm_topic_arn != null ? [var.sns_alarm_topic_arn] : []

  dimensions = {
    BucketName  = aws_s3_bucket.this.id
    StorageType = "StandardStorage"
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "bucket_requests" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.bucket_name}-high-request-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "AllRequests"
  namespace           = "AWS/S3"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.request_alarm_threshold
  alarm_description   = "Unusual number of S3 requests"
  alarm_actions       = var.sns_alarm_topic_arn != null ? [var.sns_alarm_topic_arn] : []

  dimensions = {
    BucketName = aws_s3_bucket.this.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "bucket_4xx_errors" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.bucket_name}-high-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrors"
  namespace           = "AWS/S3"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.error_alarm_threshold
  alarm_description   = "High rate of client errors"
  alarm_actions       = var.sns_alarm_topic_arn != null ? [var.sns_alarm_topic_arn] : []

  dimensions = {
    BucketName = aws_s3_bucket.this.id
  }

  tags = var.tags
}
