resource "google_project_service" "sourcerepo_googleapis_com" {
  disable_dependent_services = true
  project                    = google_project.web_shared.id
  service                    = "sourcerepo.googleapis.com"
}

resource "google_sourcerepo_repository" "terraform" {
  depends_on = [google_project_service.sourcerepo_googleapis_com]

  name = "infrastructure/terraform"
}

resource "google_sourcerepo_repository" "django" {
  depends_on = [google_project_service.sourcerepo_googleapis_com]

  name = "web/django"
}

resource "null_resource" "django_source_initialize" {
  depends_on = [
    google_sourcerepo_repository.django,
    google_artifact_registry_repository.web,
    google_cloudbuild_trigger.django_build
  ]

  provisioner "local-exec" {
    command     = <<EOT
gcloud source repos clone web/django django --project=${google_project.web_shared.project_id} && \
cd django && \
git remote rename origin csr && \
git remote add github ${var.source_git_clone_url} && \
git fetch github && \
git checkout github/${var.source_git_clone_branch} && \
git checkout ${var.source_git_clone_branch} && \
git push -u csr ${var.source_git_clone_branch} && \
echo "Checking for triggered build" && \
while [[ ! "$(gcloud builds list --filter tags=trigger-${google_cloudbuild_trigger.django_build.trigger_id} --project ${google_project.web_shared.project_id} --uri 2>/dev/null)" =~ ^https ]]; do echo "Waiting for triggered build..."; sleep 1; done && \
echo "Build triggered" && \
while [[ "$(gcloud builds list --filter tags=trigger-${google_cloudbuild_trigger.django_build.trigger_id} --project ${google_project.web_shared.project_id} --ongoing 2>/dev/null)" != "" ]]; do echo "Waiting for build to complete..."; sleep 5; done && \
echo "Build complete"
    EOT
    interpreter = ["bash", "-c"]
    working_dir = "${path.module}/../../"
  }
}


resource "null_resource" "terraform_source_initialize" {
  depends_on = [
    google_sourcerepo_repository.terraform,
    google_artifact_registry_repository.infrastructure,
    google_cloudbuild_trigger.terraform_builder,
    null_resource.django_source_initialize
  ]

  provisioner "local-exec" {
    command     = <<EOT
git remote add csr https://source.developers.google.com/p/${google_project.web_shared.project_id}/r/infrastructure/terraform && \
git add cloudbuild/cloudbuild-terraform.yaml dockerfile/Dockerfile && \
git commit -m 'Added Dockerfile and cloudbuild-terraform.yaml' && \
git push --set-upstream csr main && \
echo "Checking for triggered build" && \
while [[ ! "$(gcloud builds list --filter tags=trigger-${google_cloudbuild_trigger.terraform_builder.trigger_id} --project ${google_project.web_shared.project_id} --uri 2>/dev/null)" =~ ^https ]]; do echo "Waiting for triggered build..."; sleep 1; done && \
echo "Build triggered" && \
while [[ "$(gcloud builds list --filter tags=trigger-${google_cloudbuild_trigger.terraform_builder.trigger_id} --project ${google_project.web_shared.project_id} --ongoing 2>/dev/null)" != "" ]]; do echo "Waiting for build to complete..."; sleep 5; done && \
echo "Build complete" && \
git add --all && \
git commit -m 'Added environment configuration' && \
git push csr main
    EOT
    interpreter = ["bash", "-c"]
    working_dir = "${path.module}/../../"
  }
}
