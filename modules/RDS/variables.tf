# ============================================================================
# RDS Database Configuration Variables
# ============================================================================
# Description: Terraform variables for AWS RDS database instance deployment
# Author: Charles Bucher
# Project: Multi-Tier AWS Infrastructure
# ============================================================================

# Database Configuration
# ----------------------

variable "db_name" {
  description = "Name of the database to create on the RDS instance"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.db_name))
    error_message = "Database name must start with a letter and contain only alphanumeric characters and underscores."
  }
  
  # Example: "production_db", "app_database", "myapp_db"
}

variable "db_instance_class" {
  description = "RDS instance type (e.g., db.t3.micro, db.t3.small)"
  type        = string
  default     = "db.t3.micro"
  
  validation {
    condition     = can(regex("^db\\.", var.db_instance_class))
    error_message = "Instance class must be a valid RDS instance type starting with 'db.'."
  }
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
  
  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 65536
    error_message = "Allocated storage must be between 20 GB and 65536 GB."
  }
}

variable "db_engine" {
  description = "Database engine (mysql, postgres, mariadb)"
  type        = string
  default     = "mysql"
  
  validation {
    condition     = contains(["mysql", "postgres", "mariadb", "aurora-mysql", "aurora-postgresql"], var.db_engine)
    error_message = "Engine must be one of: mysql, postgres, mariadb, aurora-mysql, aurora-postgresql."
  }
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

# Security & Access
# -----------------

variable "username" {
  description = "Master username for RDS database"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.username)) && length(var.username) >= 1 && length(var.username) <= 16
    error_message = "Username must start with a letter, contain only alphanumeric characters and underscores, and be 1-16 characters long."
  }
  
  # Best Practice: Never use 'admin', 'root', or 'master' as username
}

variable "password" {
  description = "Master password for RDS database (minimum 8 characters)"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.password) >= 8
    error_message = "Password must be at least 8 characters long."
  }
  
  # SECURITY NOTE: Never commit passwords to Git
  # Use one of these methods:
  # 1. terraform.tfvars (in .gitignore)
  # 2. AWS Secrets Manager
  # 3. Environment variables: TF_VAR_password
  # 4. terraform apply -var="password=xxx"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = false
  
  # Set to true for production environments
  # Cost: Approximately 2x the single-AZ price
}

variable "publicly_accessible" {
  description = "Whether the database should be publicly accessible (should be false for production)"
  type        = bool
  default     = false
  
  # SECURITY: Always false for production databases
  # Access should be through bastion host or VPN
}

# Networking
# ----------

variable "subnet_group_id" {
  description = "DB subnet group name for RDS instance placement"
  type        = string
  
  # Should be a subnet group containing private subnets only
  # Example: "my-app-db-subnet-group"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with RDS instance"
  type        = list(string)
  default     = []
  
  # Security groups should allow:
  # - Inbound: Port 3306 (MySQL) or 5432 (PostgreSQL) from app tier security group
  # - Outbound: None needed for database
}

# Backup & Maintenance
# --------------------

variable "backup_retention_period" {
  description = "Number of days to retain automated backups (0-35)"
  type        = number
  default     = 7
  
  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days."
  }
  
  # Production: 7-30 days recommended
  # Development: 0-7 days acceptable
}

variable "backup_window" {
  description = "Preferred backup window (UTC timezone)"
  type        = string
  default     = "03:00-04:00"
  
  # Choose low-traffic hours for your application
  # Format: hh24:mi-hh24:mi (must be at least 30 minutes)
}

variable "maintenance_window" {
  description = "Preferred maintenance window (UTC timezone)"
  type        = string
  default     = "sun:04:00-sun:05:00"
  
  # Choose low-traffic hours for your application
  # Format: ddd:hh24:mi-ddd:hh24:mi
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS instance"
  type        = bool
  default     = false
  
  # IMPORTANT: Set to false for production to prevent data loss
  # Set to true only for temporary/test databases
}

variable "final_snapshot_identifier" {
  description = "Name of final snapshot when destroying RDS instance"
  type        = string
  default     = null
  
  # If skip_final_snapshot = false, this is required
  #
