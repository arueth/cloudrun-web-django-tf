resource "google_service_account" "web_prod" {
  account_id   = "web-prod"
  display_name = "Website Staging Service Account"
}

resource "google_artifact_registry_repository_iam_member" "cr_sa" {
  depends_on = [google_project_service.run_googleapis_com]

  location   = var.google_region_shared
  member     = "serviceAccount:service-${data.google_project.web_prod.number}@serverless-robot-prod.iam.gserviceaccount.com"
  project    = var.google_project_id_shared
  repository = "web"
  role       = "roles/artifactregistry.reader"
}
