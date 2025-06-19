terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Create projects for different environments
resource "google_project" "projects" {
  for_each = var.projects

  name            = each.value.name
  project_id      = each.value.project_id
  billing_account = var.billing_account

  labels = merge(
    var.common_labels,
    each.value.labels
  )
}

# Enable APIs for each project
resource "google_project_service" "project_apis" {
  for_each = {
    for api in local.project_apis : "${api.project_key}.${api.service}" => api
  }

  project = google_project.projects[each.value.project_key].project_id
  service = each.value.service

  disable_dependent_services = false
  disable_on_destroy        = false
}

# Create service accounts for each project
resource "google_service_account" "project_service_accounts" {
  for_each = {
    for sa in local.service_accounts : "${sa.project_key}.${sa.account_id}" => sa
  }

  account_id   = each.value.account_id
  display_name = each.value.display_name
  project      = google_project.projects[each.value.project_key].project_id
}

# Grant IAM roles to service accounts
resource "google_project_iam_member" "service_account_roles" {
  for_each = {
    for role in local.service_account_roles : "${role.project_key}.${role.account_id}.${role.role}" => role
  }

  project = google_project.projects[each.value.project_key].project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.project_service_accounts["${each.value.project_key}.${each.value.account_id}"].email}"
}

# Local variables for project configurations
locals {
  # Define APIs to enable for each project
  project_apis = [
    {
      project_key = "stoxx-demo"
      service     = "compute.googleapis.com"
    },
    {
      project_key = "stoxx-demo"
      service     = "storage.googleapis.com"
    },
    {
      project_key = "stoxx-demo"
      service     = "sqladmin.googleapis.com"
    },
    {
      project_key = "stoxx-demo"
      service     = "iam.googleapis.com"
    },
    {
      project_key = "stoxx-demo"
      service     = "cloudresourcemanager.googleapis.com"
    }
  ]

  # Define service accounts for each project
  service_accounts = [
    {
      project_key   = "stoxx-demo"
      account_id    = "stoxx-app-sa"
      display_name  = "STOXX Application Service Account"
    },
    {
      project_key   = "stoxx-demo"
      account_id    = "stoxx-admin-sa"
      display_name  = "STOXX Admin Service Account"
    }
  ]

  # Define IAM roles for service accounts
  service_account_roles = [
    {
      project_key = "stoxx-demo"
      account_id  = "stoxx-app-sa"
      role        = "roles/storage.objectViewer"
    },
    {
      project_key = "stoxx-demo"
      account_id  = "stoxx-app-sa"
      role        = "roles/compute.instanceAdmin.v1"
    },
    {
      project_key = "stoxx-demo"
      account_id  = "stoxx-admin-sa"
      role        = "roles/owner"
    }
  ]
} 