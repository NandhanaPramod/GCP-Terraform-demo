output "project_ids" {
  description = "Map of created project IDs"
  value = {
    for key, project in google_project.projects : key => project.project_id
  }
}

output "project_numbers" {
  description = "Map of created project numbers"
  value = {
    for key, project in google_project.projects : key => project.number
  }
}

output "service_accounts" {
  description = "Map of created service accounts"
  value = {
    for key, sa in google_service_account.project_service_accounts : key => {
      email = sa.email
      name  = sa.name
    }
  }
}

output "enabled_apis" {
  description = "Map of enabled APIs for each project"
  value = {
    for key, api in google_project_service.project_apis : key => {
      project = api.project
      service = api.service
    }
  }
} 