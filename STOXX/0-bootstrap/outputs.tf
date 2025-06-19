output "bootstrap_project_id" {
  description = "The ID of the bootstrap project"
  value       = google_project.bootstrap.project_id
}

output "terraform_state_bucket" {
  description = "The name of the GCS bucket for Terraform state"
  value       = google_storage_bucket.terraform_state.name
}

output "terraform_service_account_email" {
  description = "The email of the Terraform service account"
  value       = google_service_account.terraform.email
}

output "terraform_service_account_key" {
  description = "The private key for the Terraform service account"
  value       = base64decode(google_service_account_key.terraform.private_key)
  sensitive   = true
} 