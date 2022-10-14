resource "google_project_service" "artifactregistry_googleapis_com" {
  disable_dependent_services = true
  project                    = google_project.web_shared.id
  service                    = "artifactregistry.googleapis.com"
}

# This needs to be fixed, a sleep/wait should not be required.
resource "time_sleep" "ar_api_wait" {
  depends_on = [google_project_service.artifactregistry_googleapis_com]

  create_duration = "10s"
}

resource "google_artifact_registry_repository" "infrastructure" {
  depends_on = [time_sleep.ar_api_wait]

  location      = var.google_region_shared
  repository_id = "infrastructure"
  description   = "Website Repository"
  format        = "DOCKER"
}

# resource "null_resource" "terraform_container_build" {
#   depends_on = [ google_artifact_registry_repository.infrastructure ]

#   provisioner "local-exec" {
#     command = "gcloud builds submit --config $${CR_WEB_DJANGO_TF_BASE}/cloudbuild/cloudbuild-terraform.yaml --project ${google_project.web_shared.project_id} --region=global --substitutions _AR_LOCATION=${google_artifact_registry_repository.infrastructure.location},_TERRAFORM_BUILDER_TAG=${var.terraform_builder_image_tag_shared} $${CR_WEB_DJANGO_TF_BASE}/"
#   }
# }

resource "google_artifact_registry_repository" "web" {
  depends_on = [time_sleep.ar_api_wait]

  location      = var.google_region_shared
  repository_id = "web"
  description   = "Website Repository"
  format        = "DOCKER"
}
