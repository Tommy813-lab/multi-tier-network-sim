variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name (optional)"
  type        = string
  default     = null
}

variable "public_ip" {
  description = "Associate a public IP address"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "multi-tier-ec2"
}

variable "environment" {
  description = "Environment tag (dev, prod, etc.)"
  type        = string
  default     = "dev"
}

variable "extra_tags" {
  description = "Optional extra tags as a map"
  type        = map(string)
  default     = {}
}

