resource "google_project_service" "cloudbuild_googleapis_com" {
  disable_dependent_services = true
  project                    = google_project.web_shared.id
  service                    = "cloudbuild.googleapis.com"
}

resource "google_project_service" "iam_googleapis_com" {
  disable_dependent_services = true
  project                    = google_project.web_shared.id
  service                    = "iam.googleapis.com"
}

resource "google_cloudbuild_trigger" "terraform_builder" {
  depends_on = [google_project_service.cloudbuild_googleapis_com]

  filename        = "cloudbuild/cloudbuild-terraform.yaml"
  included_files  = ["dockerfile/Dockerfile"]
  location        = "global"
  name            = "terraform-builder"
  project         = google_project.web_shared.project_id
  service_account = google_service_account.terraform_builder_shared.id
  tags            = ["terraform", "builder"]

  substitutions = {
    _AR_LOCATION           = google_artifact_registry_repository.infrastructure.location
    _TERRAFORM_BUILDER_TAG = var.terraform_builder_image_tag_shared
  }
  trigger_template {
    branch_name = "main"
    repo_name   = "infrastructure/terraform"
  }
}

#resource "google_cloudbuild_trigger" "terraform_build_initialize" {
#  depends_on = [ google_project_service.cloudbuild_googleapis_com ]
#
#  filename        = "cloudbuild/cloudbuild-initialize.yaml"
#  included_files  = [ "cloudbuild/cloudbuild-initialize.yaml", "terraform/001_initialize/*" ]
#  location        = "global"
#  name            = "initialize-terraform-build"
#  project         = google_project.web_shared.project_id
#  service_account = google_service_account.terraform_builder_shared.id
#  tags            = [ "initialize", "shared", "terraform", "build" ]
#
#  trigger_template {
#    branch_name = "main"
#    repo_name   = "infrastructure/terraform"
#  }
#}

resource "google_cloudbuild_trigger" "terraform_build_shared" {
  depends_on = [google_project_service.cloudbuild_googleapis_com]

  filename        = "cloudbuild/cloudbuild-shared.yaml"
  included_files  = ["cloudbuild/cloudbuild-shared.yaml", "terraform/002_shared/*"]
  location        = "global"
  name            = "shared-terraform-build"
  project         = google_project.web_shared.project_id
  service_account = google_service_account.terraform_builder_shared.id
  tags            = ["shared", "terraform", "build"]

  substitutions = {
    _AR_LOCATION           = google_artifact_registry_repository.infrastructure.location
    _TERRAFORM_BUILDER_TAG = var.terraform_builder_image_tag_shared
  }
  trigger_template {
    branch_name = "main"
    repo_name   = "infrastructure/terraform"
  }
}

resource "google_cloudbuild_trigger" "terraform_build_dev" {
  depends_on = [google_project_service.cloudbuild_googleapis_com]

  filename        = "cloudbuild/cloudbuild-dev.yaml"
  included_files  = ["cloudbuild/cloudbuild-dev.yaml", "terraform/003_dev/*"]
  location        = "global"
  name            = "dev-terraform-build"
  project         = google_project.web_shared.project_id
  service_account = google_service_account.terraform_builder_dev.id
  tags            = ["dev", "terraform", "build"]

  substitutions = {
    _AR_LOCATION           = google_artifact_registry_repository.infrastructure.location
    _TERRAFORM_BUILDER_TAG = var.terraform_builder_image_tag_shared
  }
  trigger_template {
    branch_name = "main"
    repo_name   = "infrastructure/terraform"
  }
}

resource "google_cloudbuild_trigger" "terraform_build_stage" {
  depends_on = [google_project_service.cloudbuild_googleapis_com]

  filename        = "cloudbuild/cloudbuild-stage.yaml"
  included_files  = ["cloudbuild/cloudbuild-stage.yaml", "terraform/004_stage/*"]
  location        = "global"
  name            = "stage-terraform-build"
  project         = google_project.web_shared.project_id
  service_account = google_service_account.terraform_builder_stage.id
  tags            = ["stage", "terraform", "build"]

  substitutions = {
    _AR_LOCATION           = google_artifact_registry_repository.infrastructure.location
    _TERRAFORM_BUILDER_TAG = var.terraform_builder_image_tag_shared
  }
  trigger_template {
    branch_name = "main"
    repo_name   = "infrastructure/terraform"
  }
}

resource "google_cloudbuild_trigger" "terraform_build_prod" {
  depends_on = [google_project_service.cloudbuild_googleapis_com]

  filename        = "cloudbuild/cloudbuild-prod.yaml"
  included_files  = ["cloudbuild/cloudbuild-prod.yaml", "terraform/005_prod/*"]
  location        = "global"
  name            = "prod-terraform-build"
  project         = google_project.web_shared.project_id
  service_account = google_service_account.terraform_builder_prod.id
  tags            = ["prod", "terraform", "build"]

  substitutions = {
    _AR_LOCATION           = google_artifact_registry_repository.infrastructure.location
    _TERRAFORM_BUILDER_TAG = var.terraform_builder_image_tag_shared
  }
  trigger_template {
    branch_name = "main"
    repo_name   = "infrastructure/terraform"
  }
}

resource "google_cloudbuild_trigger" "django_build" {
  depends_on = [google_project_service.cloudbuild_googleapis_com]

  filename        = "cloudbuild/cloudbuild.yaml"
  location        = "global"
  name            = "django-build"
  service_account = google_service_account.application_builder.id
  project         = google_project.web_shared.project_id
  tags            = ["shared", "django", "build"]

  substitutions = {
    _AR_LOCATION = google_artifact_registry_repository.web.location
  }
  trigger_template {
    branch_name = "main"
    repo_name   = "web/django"
  }
}
