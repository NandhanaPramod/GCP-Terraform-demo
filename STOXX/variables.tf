variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "parent_folder" {
  description = "The ID of the parent folder where resources will be created"
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment (dev, staging, prod) for the resources"
  type        = string
  default     = "dev"
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "vpc-network"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "subnet"
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "enable_flow_logs" {
  description = "Whether to enable VPC flow logs"
  type        = bool
  default     = true
}

variable "enable_audit_logs" {
  description = "Whether to enable audit logs"
  type        = bool
  default     = true
}

variable "service_account_roles" {
  description = "List of IAM roles to assign to the service account"
  type        = list(string)
  default     = []
} 