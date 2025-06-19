terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Create a single service account for the environment
resource "google_service_account" "environment_service_account" {
  account_id   = "stoxx-env-sa"
  display_name = "STOXX Environment Service Account"
  project      = var.project_id
}

# Grant IAM roles to the environment service account
resource "google_project_iam_member" "environment_roles" {
  for_each = toset([
    "roles/viewer",
    "roles/editor",
    "roles/logging.logWriter",
    "roles/storage.objectViewer"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.environment_service_account.email}"
} 