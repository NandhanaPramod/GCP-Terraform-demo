variable "org_id" {
  description = "The organization ID"
  type        = string
}

variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "parent_folder" {
  description = "The parent folder ID"
  type        = string
  default     = ""
} 