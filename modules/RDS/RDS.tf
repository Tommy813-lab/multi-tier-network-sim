# ============================================================================
# AWS RDS Database Instance - Production-Ready Configuration
# ============================================================================
# Description: MySQL database with security, monitoring, and backup best practices
# Author: Charles Bucher
# Project: Multi-Tier AWS Infrastructure
# Security: Encrypted, private subnets only, security groups enforced
# ============================================================================

resource "aws_db_instance" "this" {
  # ============================================================================
  # IDENTIFIER & NAMING
  # ============================================================================
  identifier = "${var.environment}-${var.db_name}"
  # Creates unique identifier: "prod-myapp-db" or "dev-myapp-db"
  # Used in AWS Console and CLI commands

  # ============================================================================
  # DATABASE ENGINE CONFIGURATION
  # ============================================================================
  engine         = var.db_engine
  engine_version = var.db_engine_version
  # MySQL 8.0.x recommended for production
  # Consider using parameter_group_name for custom MySQL settings

  db_name  = var.db_name
  # FIXED: Changed from deprecated 'name' to 'db_name'
  # This is the name of the default database created on the instance

  # ============================================================================
  # INSTANCE TYPE & STORAGE
  # ============================================================================
  instance_class = var.db_instance_class
  # db.t3.micro: Development/testing (2 vCPU, 1GB RAM) - ~$12/month
  # db.t3.small: Small production (2 vCPU, 2GB RAM) - ~$25/month
  # db.t3.medium: Medium production (2 vCPU, 4GB RAM) - ~$50/month
  # db.r6g.large: High-performance (2 vCPU, 16GB RAM) - ~$125/month

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.max_allocated_storage
  # Enables storage autoscaling up to max_allocated_storage
  # Prevents manual intervention when disk fills up
  # Example: allocated_storage = 20, max_allocated_storage = 100

  storage_type = var.storage_type
  # gp3: Latest generation, best cost/performance (RECOMMENDED)
  # gp2: Previous generation
  # io1/io2: Provisioned IOPS for high-performance databases

  iops = var.storage_type == "io1" || var.storage_type == "io2" ? var.iops : null
  # Only needed for io1/io2 storage types
  # Range: 1000-256000 IOPS

  # ============================================================================
  # SECURITY - CREDENTIALS
  # ============================================================================
  username = var.username
  password = var.password
  # SECURITY BEST PRACTICE: Never hardcode credentials
  # Use one of these methods:
  # 1. AWS Secrets Manager (RECOMMENDED)
  # 2. Terraform Cloud/Enterprise secure variables
  # 3. Environment variables: TF_VAR_password
  # 4. terraform.tfvars (in .gitignore)

  # ============================================================================
  # SECURITY - ENCRYPTION AT REST
  # ============================================================================
  storage_encrypted = var.storage_encrypted
  # CRITICAL: Must be true for production
  # Required for: PCI-DSS, HIPAA, SOC 2 compliance
  # Cannot be changed after creation - must recreate database

  kms_key_id = var.kms_key_id
  # Uses AWS-managed key if null
  # For production, use customer-managed KMS key for better control

  # ============================================================================
  # SECURITY - NETWORK ISOLATION
  # ============================================================================
  db_subnet_group_name = var.subnet_group_id
  # MUST be private subnets only (no internet gateway route)
  # Typically includes subnets in multiple AZs
  # Example: ["subnet-private-db-1a", "subnet-private-db-1b"]

  vpc_security_group_ids = var.vpc_security_group_ids
  # CRITICAL: Security group should restrict access
  # Recommended rules:
  # - Inbound: Port 3306 from application security group ONLY
  # - Outbound: None (database doesn't need outbound access)

  publicly_accessible = var.publicly_accessible
  # SECURITY: Must be false for production
  # Never expose database to internet
  # Access should be through:
  # - Bastion host in public subnet
  # - VPN connection
  # - AWS Systems Manager Session Manager

  # ============================================================================
  # HIGH AVAILABILITY - MULTI-AZ
  # ============================================================================
  multi_az = var.multi_az
  # Production: true (automatic failover to standby in different AZ)
  # Development: false (cost savings)
  # Multi-AZ costs approximately 2x single-AZ pricing
  # Provides:
  # - Automatic failover (1-2 minutes)
  # - Synchronous replication
  # - 99.95% availability SLA

  availability_zone = var.multi_az ? null : var.availability_zone
  # Only specify if single-AZ deployment
  # For Multi-AZ, AWS automatically selects AZs

  # ============================================================================
  # BACKUP & DISASTER RECOVERY
  # ============================================================================
  backup_retention_period = var.backup_retention_period
  # 0: Automated backups disabled (NOT RECOMMENDED)
  # 1-35: Days to retain automated backups
  # Production: 7-30 days recommended
  # Development: 1-7 days acceptable
  # Required for: Point-in-time recovery (PITR)

  backup_window = var.backup_window
  # Preferred daily backup window (UTC timezone)
  # Format: HH:MM-HH:MM (must be at least 30 minutes)
  # Choose low-traffic hours for your application
  # Example: "03:00-04:00" (3 AM - 4 AM UTC)

  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  # Copies all tags to automated backups and snapshots
  # Useful for: Cost tracking, compliance, organization

  skip_final_snapshot = var.skip_final_snapshot
  # DANGER: If true, no snapshot taken when database is deleted
  # Production: false (ALWAYS create final snapshot)
  # Development/Testing: true (for easier cleanup)

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.environment}-${var.db_name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  # Required if skip_final_snapshot = false
  # Naming convention includes timestamp for uniqueness
  # Example: "prod-myapp-db-final-snapshot-2024-10-16-1430"

  delete_automated_backups = var.delete_automated_backups
  # true: Delete automated backups when DB is deleted
  # false: Keep backups according to retention period

  deletion_protection = var.deletion_protection
  # CRITICAL FOR PRODUCTION: Must be true
  # Prevents accidental database deletion via API/Console/Terraform
  # Must manually disable before deletion

  # ============================================================================
  # MAINTENANCE & UPDATES
  # ============================================================================
  maintenance_window = var.maintenance_window
  # Preferred weekly maintenance window (UTC timezone)
  # Format: ddd:HH:MM-ddd:HH:MM (e.g., "sun:04:00-sun:05:00")
  # Used for: OS patching, database engine upgrades, etc.
  # Choose low-traffic hours

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  # true: Automatically apply minor version upgrades during maintenance
  # false: Require manual approval (more control, but manual work)
  # Production: false (test upgrades in dev first)
  # Development: true (stay current automatically)

  apply_immediately = var.apply_immediately
  # true: Apply changes immediately (causes downtime)
  # false: Apply during next maintenance window (RECOMMENDED)
  # Use apply_immediately = true only for emergencies

  # ============================================================================
  # MONITORING & LOGGING
  # ============================================================================
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  # MySQL: ["error", "general", "slowquery"]
  # PostgreSQL: ["postgresql", "upgrade"]
  # Exports logs to CloudWatch Logs for analysis
  # Use CloudWatch Logs Insights for querying

  monitoring_interval = var.monitoring_interval
  # 0: Disabled
  # 1, 5, 10, 15, 30, 60: Seconds between metric collections
  # Recommended: 60 seconds for production
  # Cost: ~$0.01 per vCPU per hour for enhanced monitoring

  monitoring_role_arn = var.monitoring_interval > 0 ? var.monitoring_role_arn : null
  # Required if monitoring_interval > 0
  # IAM role that allows RDS to send metrics to CloudWatch
  # Create with: aws_iam_role.rds_enhanced_monitoring

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  # Performance Insights analyzes database load and wait events
  # 7 days: Free tier
  # 731 days (2 years): Additional cost (~$0.018 per vCPU-hour)
  # Invaluable for: Query optimization, performance troubleshooting

  performance_insights_kms_key_id = var.performance_insights_enabled && var.performance_insights_kms_key_id != null ? var.performance_insights_kms_key_id : null
  # Optional: Encrypt Performance Insights data with custom KMS key

  # ============================================================================
  # PARAMETER & OPTION GROUPS (ADVANCED)
  # ============================================================================
  parameter_group_name = var.parameter_group_name
  # Custom DB parameter group for MySQL settings
  # Examples:
  # - max_connections
  # - innodb_buffer_pool_size
  # - slow_query_log
  # Create separate parameter group resource for production

  option_group_name = var.option_group_name
  # Custom option group for MySQL plugins/features
  # Examples:
  # - MARIADB_AUDIT_PLUGIN (for audit logging)
  # - MEMCACHED (for query caching)

  # ============================================================================
  # LICENSING (Not applicable for MySQL)
  # ============================================================================
  # license_model = "general-public-license"
  # Only relevant for Oracle and SQL Server

  # ============================================================================
  # CHARACTER SET & COLLATION
  # ============================================================================
  character_set_name = var.character_set_name
  # MySQL default: utf8mb4 (RECOMMENDED - full Unicode support)
  # Older: utf8 (limited emoji support)

  # ============================================================================
  # TAGS FOR COST TRACKING & ORGANIZATION
  # ============================================================================
  tags = merge(
    var.tags,
    {
      Name                = "${var.environment}-${var.db_name}"
      Environment         = var.environment
      ManagedBy           = "Terraform"
      Component           = "Database"
      Service             = "RDS"
      CostCenter          = var.cost_center
      DataClassification  = var.data_classification
      BackupSchedule      = "${var.backup_retention_period} days"
      MultiAZ             = var.multi_az
      Encrypted           = var.storage_encrypted
    }
  )
  # Tags used for:
  # - Cost allocation reports
  # - Resource organization
  # - Compliance auditing
  # - Automation scripts

  # ============================================================================
  # LIFECYCLE MANAGEMENT
  # ============================================================================
  lifecycle {
    # Prevent accidental destruction of database
    prevent_destroy = var.environment == "prod" ? true : false

    # Ignore changes to password (managed externally)
    ignore_changes = [
      password,
      # Don't recreate DB if password changes via Secrets Manager rotation
    ]

    # Must create new DB before destroying old one (for upgrades)
    create_before_destroy = false
    # Note: RDS doesn't support create_before_destroy well
    # Use blue-green deployments or read replicas for zero-downtime upgrades
  }

  # ============================================================================
  # DEPENDENCIES
  # ============================================================================
  depends_on = [
    # Ensure subnet group exists before creating database
    # Ensure security groups exist before creating database
    # Add your subnet group and security group resources here
  ]
}

# ============================================================================
# CLOUDWATCH ALARMS FOR PROACTIVE MONITORING
# ============================================================================

resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.environment}-${var.db_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Database CPU utilization is too high"
  alarm_actions       = var.sns_alarm_topic_arn != null ? [var.sns_alarm_topic_arn] : []

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "database_storage" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.environment}-${var.db_name}-low-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "5000000000" # 5GB in bytes
  alarm_description   = "Database free storage space is low"
  alarm_actions       = var.sns_alarm_topic_arn != null ? [var.sns_alarm_topic_arn] : []

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "database_memory" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.environment}-${var.db_name}-low-memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "256000000" # 256MB in bytes
  alarm_description   = "Database freeable memory is too low"
  alarm_actions       = var.sns_alarm_topic_arn != null ? [var.sns_alarm_topic_arn] : []

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "database_connections" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.environment}-${var.db_name}-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Database connections are too high"
  alarm_actions       = var.sns_alarm_topic_arn != null ? [var.sns_alarm_topic_arn] : []

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }

  tags = var.tags
}
