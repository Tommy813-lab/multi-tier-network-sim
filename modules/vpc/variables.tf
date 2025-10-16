variable "cidr_block" {
  description = "The CIDR block for the VPC (must be a valid IPv4 CIDR, e.g., 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"  # optional default

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "The cidr_block must be a valid IPv4 CIDR notation."
  }
}
