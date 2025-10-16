# ============================================================================
# RDS Database Instance Outputs
# ============================================================================
# Description: Output values for RDS database connection and monitoring
# Author: Charles Bucher
# Project: Multi-Tier AWS Infrastructure
# Security: Some outputs marked sensitive to prevent exposure in logs
# ============================================================================

# Database Connection Information
# --------------------------------

output "db_instance_endpoint" {
  description = "Connection endpoint in address:port format (e.g., mydb.abc123.us-east-1.rds.amazonaws.com:3306)"
  value       = aws_db_instance.this.endpoint
  
  # Used by application servers to connect to database
  # Format: hostname:port
  # Example: myapp-db.c1a2b3c4d5e6.us-east-1.rds.amazonaws.com:3306
}

output "db_instance_address" {
  description = "Hostname of the RDS instance (without port)"
  value       = aws_db_instance.this.address
  
  # Use this when specifying port separately in application config
  # Example: myapp-db.c1a2b3c4d5e6.us-east-1.rds.amazonaws.com
}

output "db_instance_port" {
  description = "Database port number"
  value       = aws_db_instance.this.port
  
  # MySQL: 3306
  # PostgreSQL: 5432
  # MariaDB: 3306
}

output "db_instance_name" {
  description = "Name of the default database created on the instance"
  value       = aws_db_instance.this.db_name
}

# Resource Identifiers
# ---------------------

output "db_instance_id" {
  description = "RDS instance identifier for AWS API calls"
  value       = aws_db_instance.this.id
  
  # Used for: AWS CLI commands, CloudWatch metrics, API operations
  # Example: myapp-production-db
}

output "db_instance_arn" {
  description = "ARN of the RDS instance for IAM policies and tagging"
  value       = aws_db_instance.this.arn
  
  # Used for: IAM policies, resource tagging, CloudFormation
  # Format: arn:aws:rds:us-east-1:123456789012:db:myapp-production-db
}

output "db_instance_resource_id" {
  description = "RDS resource ID (unique identifier across regions)"
  value       = aws_db_instance.this.resource_id
  
  # Used for: Performance Insights, Enhanced Monitoring
  # Format: db-ABCDEFGHIJKLMNOPQRSTUVWXYZ
}

# Connection String Builder
# -------------------------

output "db_connection_string" {
  description = "Full database connection string (MySQL format - SENSITIVE)"
  value       = format(
    "mysql://%s:%s@%s:%s/%s",
    aws_db_instance.this.username,
    var.password,
    aws_db_instance.this.address,
    aws_db_instance.this.port,
    aws_db_instance.this.db_name
  )
  sensitive = true
  
  # Format: mysql://username:password@host:port/database
  # WARNING: Contains password - marked as sensitive
  # Used for: Quick testing, connection string generation
}

output "db_connection_params" {
  description = "Database connection parameters as map for application configuration"
  value = {
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    database = aws_db_instance.this.db_name
    username = aws_db_instance.this.username
    # password excluded - retrieve from AWS Secrets Manager in application
  }
  
  # Use this to populate application environment variables
  # Password should be fetched separately from Secrets Manager
}

# Security & Networking
# ----------------------

output "db_security_group_id" {
  description = "Security group ID attached to RDS instance"
  value       = try(aws_db_instance.this.vpc_security_group_ids[0], null)
  
  # Use to reference in other security group rules
}

output "db_subnet_group_name" {
  description = "DB subnet group name used by RDS instance"
  value       = aws_db_instance.this.db_subnet_group_name
  
  # Indicates which subnets the database is deployed in
}

output "db_availability_zone" {
  description = "Availability zone where RDS instance is deployed"
  value       = aws_db_instance.this.availability_zone
  
  # Single-AZ: Shows specific AZ
  # Multi-AZ: Shows primary AZ (standby is in different AZ)
}

output "db_multi_az" {
  description = "Whether Multi-AZ deployment is enabled"
  value       = aws_db_instance.this.multi_az
  
  # true = High availability with automatic failover
  # false = Single AZ deployment
}

# Monitoring & Management
# -----------------------

output "db_instance_status" {
  description = "Current status of the RDS instance"
  value       = aws_db_instance.this.status
  
  # Possible values: available, backing-up, creating, deleting, 
  # failed, modifying, rebooting, resetting-master-credentials, etc.
}

output "db_cloudwatch_log_groups" {
  description = "CloudWatch Log Groups for database logs"
  value       = aws_db_instance.this.enabled_cloudwatch_logs_exports
  
  # Lists enabled log types (error, general, slowquery, etc.)
  # Use for: CloudWatch Logs Insights queries, log monitoring
}

output "db_monitoring_role_arn" {
  description = "IAM role ARN used for enhanced monitoring"
  value       = aws_db_instance.this.monitoring_role_arn
  
  # Required for Enhanced Monitoring in CloudWatch
}

output "db_performance_insights_enabled" {
  description = "Whether Performance Insights is enabled"
  value       = aws_db_instance.this.performance_insights_enabled
  
  # true = Query performance analysis available in RDS console
}

# Backup & Recovery
# -----------------

output "db_backup_retention_period" {
  description = "Number of days automated backups are retained"
  value       = aws_db_instance.this.backup_retention_period
  
  # 0 = automated backups disabled
  # 1-35 = days to retain backups
}

output "db_backup_window" {
  description = "Daily time range for automated backups (UTC)"
  value       = aws_db_instance.this.backup_window
  
  # Format: HH:MM-HH:MM (e.g., 03:00-04:00)
}

output "db_maintenance_window" {
  description = "Weekly time range for system maintenance (UTC)"
  value       = aws_db_instance.this.maintenance_window
  
  # Format: ddd:HH:MM-ddd:HH:MM (e.g., sun:04:00-sun:05:00)
}

output "db_latest_restorable_time" {
  description = "Latest point-in-time to which database can be restored"
  value       = aws_db_instance.this.latest_restorable_time
  
  # Used for: Disaster recovery planning, backup verification
}

# Storage & Performance
# ---------------------

output "db_allocated_storage" {
  description = "Allocated storage size in GB"
  value       = aws_db_instance.this.allocated_storage
}

output "db_storage_type" {
  description = "Storage type (gp2, gp3, io1, io2)"
  value       = aws_db_instance.this.storage_type
  
  # gp3: General Purpose SSD (latest generation)
  # io1/io2: Provisioned IOPS for high performance
}

output "db_storage_encrypted" {
  description = "Whether storage encryption is enabled"
  value       = aws_db_instance.this.storage_encrypted
  
  # true = Data encrypted at rest using KMS
  # Required for: PCI-DSS, HIPAA compliance
}

output "db_kms_key_id" {
  description = "KMS key ID used for storage encryption"
  value       = aws_db_instance.this.kms_key_id
  
  # Shows which KMS key encrypts the database
}

output "db_iops" {
  description = "Provisioned IOPS (if applicable)"
  value       = aws_db_instance.this.iops
  
  # Only relevant for io1/io2 storage types
}

# Engine Information
# ------------------

output "db_engine" {
  description = "Database engine type"
  value       = aws_db_instance.this.engine
  
  # mysql, postgres, mariadb, etc.
}

output "db_engine_version" {
  description = "Database engine version"
  value       = aws_db_instance.this.engine_version
  
  # Example: 8.0.35 (MySQL), 15.3 (PostgreSQL)
}

output "db_engine_version_actual" {
  description = "Running engine version (may differ during upgrades)"
  value       = aws_db_instance.this.engine_version_actual
  
  # Shows actual version if different from requested version
}

# Cost Management
# ---------------

output "db_instance_class" {
  description = "Instance type for cost tracking"
  value       = aws_db_instance.this.instance_class
  
  # Example: db.t3.micro, db.t3.small, db.r6g.large
  # Use for: Cost analysis, capacity planning
}

output "db_deletion_protection" {
  description = "Whether deletion protection is enabled"
  value       = aws_db_instance.this.deletion_protection
  
  # true = Cannot delete without first disabling protection
  # PRODUCTION: Should always be true
}

# Tags for Resource Management
# -----------------------------

output "db_tags" {
  description = "Tags applied to RDS instance"
  value       = aws_db_instance.this.tags_all
  
  # Use for: Cost allocation, resource organization
}

# Connection Instructions (Non-sensitive)
# ----------------------------------------

output "connection_instructions" {
  description = "Instructions for connecting to the database"
  value = <<-EOT
    Database Connection Information:
    
    Endpoint: ${aws_db_instance.this.endpoint}
    Host:     ${aws_db_instance.this.address}
    Port:     ${aws_db_instance.this.port}
    Database: ${aws_db_instance.this.db_name}
    Username: ${aws_db_instance.this.username}
    
    MySQL Connection Command:
    mysql -h ${aws_db_instance.this.address} \
          -P ${aws_db_instance.this.port} \
          -u ${aws_db_instance.this.username} \
          -p \
          ${aws_db_instance.this.db_name}
    
    PostgreSQL Connection Command:
    psql -h ${aws_db_instance.this.address} \
         -p ${aws_db_instance.this.port} \
         -U ${aws_db_instance.this.username} \
         -d ${aws_db_instance.this.db_name}
    
    Connection String (MySQL):
    mysql://${aws_db_instance.this.username}:[PASSWORD]@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${aws_db_instance.this.db_name}
    
    SECURITY NOTE: 
    - Password should be retrieved from AWS Secrets Manager
    - Secret ARN: [Your Secrets Manager ARN here]
    - Never hardcode passwords in application code
    
    Multi-AZ: ${aws_db_instance.this.multi_az}
    Encryption: ${aws_db_instance.this.storage_encrypted}
    Backup Retention: ${aws_db_instance.this.backup_retention_period} days
  EOT
}

# Application Configuration Export
# ---------------------------------

output "application_config" {
  description = "Configuration object for application environment variables"
  value = {
    DB_HOST     = aws_db_instance.this.address
    DB_PORT     = tostring(aws_db_instance.this.port)
    DB_NAME     = aws_db_instance.this.db_name
    DB_USER     = aws_db_instance.this.username
    DB_ENGINE   = aws_db_instance.this.engine
    # DB_PASSWORD should be fetched from AWS Secrets Manager
    DB_SECRETS_ARN = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.environment}/db/password"
  }
  
  # Use this to populate application configuration
  # Example: Export to .env file or container environment variables
}

# Terraform State Reference
# --------------------------

output "db_instance_terraform_resource" {
  description = "Terraform resource reference for dependencies"
  value       = "aws_db_instance.this"
  
  # Use in other modules: depends_on = [module.rds.db_instance_terraform_resource]
}
