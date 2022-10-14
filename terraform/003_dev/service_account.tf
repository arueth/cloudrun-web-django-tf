resource "google_service_account" "web_dev" {
  account_id   = "web-dev"
  display_name = "Website Development Service Account"
}

resource "google_artifact_registry_repository_iam_member" "cr_sa" {
  depends_on = [google_project_service.run_googleapis_com]

  location   = var.google_region_shared
  member     = "serviceAccount:service-${data.google_project.web_dev.number}@serverless-robot-prod.iam.gserviceaccount.com"
  project    = var.google_project_id_shared
  repository = "web"
  role       = "roles/artifactregistry.reader"
}
