variable "project_id" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "org_id" {
  description = "The organization ID for the associated resources"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate with the project"
  type        = string
}

variable "region" {
  description = "The region in which resources will be created"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "The environment (dev, staging, prod) for the resources"
  type        = string
  default     = "dev"
} 