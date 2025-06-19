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

# Network Module
module "network" {
  source = "./3-networks"
  
  project_id = var.project_id
  region     = var.region
}

# Application Infrastructure Module
module "app_infra" {
  source = "./5-app-infra"
  
  project_id = var.project_id
  region     = var.region
  
  depends_on = [module.network]
} 