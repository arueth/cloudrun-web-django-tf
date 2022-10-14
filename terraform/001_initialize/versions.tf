terraform {
  backend "local" {
    path = "state/default.tfstate"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.47.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }

  required_version = "~> 1.3.5"
}

provider "google" {
  project = var.google_project_id_shared
  region  = var.google_region_shared
  zone    = var.google_zone_shared
}

provider "google-beta" {
  project = var.google_project_id_shared
  region  = var.google_region_shared
  zone    = var.google_zone_shared
}

provider "local" {
}

provider "time" {
}
