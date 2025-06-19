terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Create a service account for SonarQube
resource "google_service_account" "sonarqube_service_account" {
  account_id   = "sonarqube-service-account"
  display_name = "SonarQube Service Account"
  project      = var.project_id
}

# Enable Cloud Run API (if not already enabled)
resource "google_project_service" "cloud_run_api" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy        = false
}

# Create SonarQube Cloud Run service
resource "google_cloud_run_service" "sonarqube_service" {
  name     = "stoxx-sonarqube"
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = "sonarqube:latest"
        
        ports {
          container_port = 9000
        }

        resources {
          limits = {
            cpu    = "2000m"
            memory = "4Gi"
          }
          requests = {
            cpu    = "1000m"
            memory = "2Gi"
          }
        }

        env {
          name  = "SONAR_ES_BOOTSTRAP_CHECKS_DISABLE"
          value = "true"
        }

        env {
          name  = "SONAR_WEB_JAVAOPTS"
          value = "-Xmx2g -Xms1g -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
        }

        env {
          name  = "SONAR_CE_JAVAOPTS"
          value = "-Xmx2g -Xms1g -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
        }

        env {
          name  = "SONAR_SEARCH_JAVAOPTS"
          value = "-Xmx1g -Xms512m -XX:+UseG1GC"
        }

        env {
          name  = "SONAR_ES_STARTUP_TIMEOUT"
          value = "300"
        }

        env {
          name  = "SONAR_ES_CONNECT_TIMEOUT"
          value = "60"
        }

        env {
          name  = "SONAR_ES_SOCKET_TIMEOUT"
          value = "60"
        }

        env {
          name  = "SONAR_ES_REQUEST_TIMEOUT"
          value = "60"
        }

        env {
          name  = "SONAR_JDBC_URL"
          value = "jdbc:h2:tcp://localhost:9092/sonar;NON_KEYWORDS=VALUE;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE"
        }

        env {
          name  = "SONAR_JDBC_USERNAME"
          value = "sonar"
        }

        env {
          name  = "SONAR_JDBC_PASSWORD"
          value = "sonar"
        }

        env {
          name  = "SONAR_EMBEDDEDDATABASE_PORT"
          value = "9092"
        }
      }

      service_account_name = google_service_account.sonarqube_service_account.email
      timeout_seconds      = 900
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.cloud_run_api]
}

# Create IAM policy to allow unauthenticated access
resource "google_cloud_run_service_iam_member" "sonarqube_public_access" {
  location = google_cloud_run_service.sonarqube_service.location
  project  = google_cloud_run_service.sonarqube_service.project
  service  = google_cloud_run_service.sonarqube_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Grant SonarQube service account necessary permissions
resource "google_project_iam_member" "sonarqube_permissions" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/storage.objectViewer"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.sonarqube_service_account.email}"
} 