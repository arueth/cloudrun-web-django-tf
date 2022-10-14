resource "google_project" "web_shared" {
  billing_account = var.google_billing_account_shared
  folder_id       = var.google_project_folder_id_shared
  name            = "web-shared"
  project_id      = var.google_project_id_shared
  skip_delete     = true
}

resource "google_project" "web_dev" {
  billing_account = var.google_billing_account_dev
  folder_id       = var.google_project_folder_id_dev
  name            = "web-dev"
  project_id      = var.google_project_id_dev
  skip_delete     = false
}

resource "google_project" "web_stage" {
  billing_account = var.google_billing_account_stage
  folder_id       = var.google_project_folder_id_stage
  name            = "web-staging"
  project_id      = var.google_project_id_stage
  skip_delete     = false
}

resource "google_project" "web_prod" {
  billing_account = var.google_billing_account_prod
  folder_id       = var.google_project_folder_id_prod
  name            = "web-prod"
  project_id      = var.google_project_id_prod
  skip_delete     = false
}

resource "google_project_service" "cloudresourcemanager_googleapis_com_shared" {
  disable_dependent_services = true
  project                    = google_project.web_shared.id
  service                    = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager_googleapis_com_dev" {
  disable_dependent_services = true
  project                    = google_project.web_dev.id
  service                    = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager_googleapis_com_stage" {
  disable_dependent_services = true
  project                    = google_project.web_stage.id
  service                    = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager_googleapis_com_prod" {
  disable_dependent_services = true
  project                    = google_project.web_prod.id
  service                    = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "serviceusage_googleapis_com_shared" {
  disable_dependent_services = true
  project                    = google_project.web_shared.id
  service                    = "serviceusage.googleapis.com"
}

resource "google_project_service" "serviceusage_googleapis_com_dev" {
  disable_dependent_services = true
  project                    = google_project.web_dev.id
  service                    = "serviceusage.googleapis.com"
}

resource "google_project_service" "serviceusage_googleapis_com_stage" {
  disable_dependent_services = true
  project                    = google_project.web_stage.id
  service                    = "serviceusage.googleapis.com"
}

resource "google_project_service" "serviceusage_googleapis_com_prod" {
  disable_dependent_services = true
  project                    = google_project.web_prod.id
  service                    = "serviceusage.googleapis.com"
}

resource "google_project_service" "sqladmin_googleapis_com" {
  disable_dependent_services = true
  project                    = google_project.web_shared.id
  service                    = "sqladmin.googleapis.com"
}
