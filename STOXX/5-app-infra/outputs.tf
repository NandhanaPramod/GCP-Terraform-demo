output "app_service_account_email" {
  description = "The email of the application service account"
  value       = google_service_account.app_service_account.email
}

output "app_bucket_name" {
  description = "The name of the application storage bucket"
  value       = google_storage_bucket.app_bucket.name
}

output "cloud_run_service_url" {
  description = "The URL of the Cloud Run service"
  value       = google_cloud_run_service.app_service.status[0].url
}

output "cloud_run_service_name" {
  description = "The name of the Cloud Run service"
  value       = google_cloud_run_service.app_service.name
} 