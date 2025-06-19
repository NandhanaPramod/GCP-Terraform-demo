variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "projects" {
  description = "Map of projects to create"
  type = map(object({
    name       = string
    project_id = string
    labels     = map(string)
  }))
}

variable "common_labels" {
  description = "Common labels to apply to all projects"
  type        = map(string)
  default = {
    managed_by = "terraform"
    project    = "stoxx"
  }
}

variable "parent_folder" {
  description = "The parent folder ID"
  type        = string
  default     = ""
} 