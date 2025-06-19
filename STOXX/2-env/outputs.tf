output "environment_service_account_email" {
  description = "The email of the environment service account"
  value       = google_service_account.environment_service_account.email
}
 
output "environment_service_account_name" {
  description = "The name of the environment service account"
  value       = google_service_account.environment_service_account.name
} 