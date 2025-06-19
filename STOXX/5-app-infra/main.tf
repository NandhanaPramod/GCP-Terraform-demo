terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Application infrastructure resources will be defined here 

# Create a service account for the application
resource "google_service_account" "app_service_account" {
  account_id   = "app-service-account"
  display_name = "Application Service Account"
  project      = var.project_id
}

# Create a Cloud Storage bucket
resource "google_storage_bucket" "app_bucket" {
  name          = "${var.project_id}-app-bucket"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
}

# Enable Cloud Run API
resource "google_project_service" "cloud_run_api" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy        = false
}

# Create Cloud Run service
resource "google_cloud_run_service" "app_service" {
  name     = "stoxx-app"
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = var.container_image
        
        ports {
          container_port = var.container_port
        }

        resources {
          limits = {
            cpu    = "2000m"
            memory = "1Gi"
          }
          requests = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }

        env {
          name  = "STORAGE_BUCKET"
          value = google_storage_bucket.app_bucket.name
        }

        env {
          name  = "HOST"
          value = "0.0.0.0"
        }
      }

      service_account_name = google_service_account.app_service_account.email
      timeout_seconds      = 600
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.cloud_run_api]
}

# Create IAM policy to allow unauthenticated access (optional)
resource "google_cloud_run_service_iam_member" "public_access" {
  count    = var.allow_unauthenticated ? 1 : 0
  location = google_cloud_run_service.app_service.location
  project  = google_cloud_run_service.app_service.project
  service  = google_cloud_run_service.app_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Grant Cloud Run service account necessary permissions
resource "google_project_iam_member" "cloud_run_permissions" {
  for_each = toset([
    "roles/storage.objectViewer",
    "roles/logging.logWriter"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

# GitHub Actions Service Account for CI/CD
resource "google_service_account" "github_actions" {
  account_id   = "github-actions-deployer"
  display_name = "GitHub Actions Deployer"
  project      = var.project_id
}

resource "google_project_iam_member" "github_actions_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
} 