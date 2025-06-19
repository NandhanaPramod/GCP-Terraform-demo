output "sonarqube_service_url" {
  description = "The URL of the SonarQube service"
  value       = google_cloud_run_service.sonarqube_service.status[0].url
}

output "sonarqube_service_name" {
  description = "The name of the SonarQube service"
  value       = google_cloud_run_service.sonarqube_service.name
}

output "sonarqube_service_account_email" {
  description = "The email of the SonarQube service account"
  value       = google_service_account.sonarqube_service_account.email
} 