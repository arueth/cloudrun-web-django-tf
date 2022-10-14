###############################################################################
# TERRAFORM BUILDER
###############################################################################
resource "google_service_account" "terraform_builder_shared" {
  account_id   = "terraform-builder-shared"
  display_name = "Website Shared Terraform Builder Service Account"
  project      = google_project.web_shared.project_id
}

resource "google_project_iam_member" "terraform_builder_shared" {
  member  = google_service_account.terraform_builder_shared.member
  project = google_project.web_shared.id
  role    = "roles/owner"
}

#####################################################################

resource "google_service_account" "terraform_builder_dev" {
  account_id   = "terraform-builder-dev"
  display_name = "Website Development Terraform Builder Service Account"
  project      = google_project.web_shared.project_id
}

resource "google_project_iam_member" "terraform_builder_dev" {
  member  = google_service_account.terraform_builder_dev.member
  project = google_project.web_dev.id
  role    = "roles/owner"
}

resource "google_project_iam_member" "terraform_builder_dev_shared" {
  member  = google_service_account.terraform_builder_dev.member
  project = google_project.web_shared.id
  role    = "roles/owner"
}

#####################################################################

resource "google_service_account" "terraform_builder_stage" {
  account_id   = "terraform-builder-stage"
  display_name = "Website Staging Terraform Builder Service Account"
  project      = google_project.web_shared.project_id
}

resource "google_project_iam_member" "terraform_builder_stage" {
  member  = google_service_account.terraform_builder_stage.member
  project = google_project.web_stage.id
  role    = "roles/owner"
}

resource "google_project_iam_member" "terraform_builder_stage_shared" {
  member  = google_service_account.terraform_builder_stage.member
  project = google_project.web_shared.id
  role    = "roles/owner"
}

#####################################################################

resource "google_service_account" "terraform_builder_prod" {
  account_id   = "terraform-builder-prod"
  display_name = "Website Production Terraform Builder Service Account"
  project      = google_project.web_shared.project_id
}

resource "google_project_iam_member" "terraform_builder_prod" {
  member  = google_service_account.terraform_builder_prod.member
  project = google_project.web_prod.id
  role    = "roles/owner"
}

resource "google_project_iam_member" "terraform_builder_prod_shared" {
  member  = google_service_account.terraform_builder_prod.member
  project = google_project.web_shared.id
  role    = "roles/owner"
}



###############################################################################
# APPLICATION BUILDER
###############################################################################
resource "google_service_account" "application_builder" {
  account_id   = "application-builder"
  display_name = "Website Application Builder Service Account"
  project      = google_project.web_shared.project_id
}

resource "google_project_iam_member" "application_builder" {
  member  = google_service_account.application_builder.member
  project = google_project.web_shared.id
  role    = "roles/owner"
}
