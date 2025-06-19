terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Create the bootstrap project
resource "google_project" "bootstrap" {
  name            = "bootstrap-${var.environment}"
  project_id      = "bootstrap-${var.environment}-${random_string.suffix.result}"
  org_id          = var.org_id
  billing_account = var.billing_account
}

# Create a random suffix for the project ID
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com"
  ])

  project = google_project.bootstrap.project_id
  service = each.key

  disable_dependent_services = false
  disable_on_destroy        = false
}

# Create GCS bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name          = "terraform-state-${var.environment}-${random_string.suffix.result}"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }

  depends_on = [google_project_service.required_apis]
}

# Create service account for Terraform
resource "google_service_account" "terraform" {
  account_id   = "terraform-${var.environment}"
  display_name = "Terraform Service Account"
  project      = google_project.bootstrap.project_id
}

# Grant necessary IAM roles to the service account
resource "google_project_iam_member" "terraform_roles" {
  for_each = toset([
    "roles/storage.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/billing.user"
  ])

  project = google_project.bootstrap.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

# Create service account key
resource "google_service_account_key" "terraform" {
  service_account_id = google_service_account.terraform.name
} 