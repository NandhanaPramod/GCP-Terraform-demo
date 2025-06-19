variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "container_image" {
  description = "The container image URL for Cloud Run"
  type        = string
  default     = "gcr.io/your-project/your-app:latest"
}

variable "container_port" {
  description = "The port your container listens on"
  type        = number
  default     = 8080
}

variable "cpu_limit" {
  description = "CPU limit for Cloud Run service"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for Cloud Run service"
  type        = string
  default     = "512Mi"
}

variable "allow_unauthenticated" {
  description = "Whether to allow unauthenticated access to Cloud Run service"
  type        = bool
  default     = false
} 