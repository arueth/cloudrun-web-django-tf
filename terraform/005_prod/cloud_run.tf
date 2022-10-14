locals {
  cloud_run_image_tag = var.cloudrun_image_tag_prod != "" ? var.cloudrun_image_tag_prod : var.cloudrun_image_tag_default
  cloud_run_image     = "${var.google_region_shared}-docker.pkg.dev/${var.google_project_id_shared}/web/django:${local.cloud_run_image_tag}"
}

resource "google_project_service" "run_googleapis_com" {
  disable_dependent_services = true
  service                    = "run.googleapis.com"
}

resource "google_project_service" "sql_component_googleapis_com" {
  disable_dependent_services = true
  service                    = "sql-component.googleapis.com"
}

resource "google_cloud_run_v2_service" "web_django" {
  depends_on = [google_project_service.run_googleapis_com, google_artifact_registry_repository_iam_member.cr_sa]

  location = var.google_region_prod
  name     = "web-django"

  template {
    containers {
      env {
        name  = "ENVIRONMENT"
        value = "prod"
      }
      image = local.cloud_run_image
      ports {
        container_port = 8080
        name           = "http1"
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
    }
    service_account = google_service_account.web_prod.email
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.prod.connection_name]
      }
    }
  }
  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}

data "google_iam_policy" "allow_unauthenticated_invocations" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "allow_unauthenticated_invocations" {
  location    = google_cloud_run_v2_service.web_django.location
  policy_data = data.google_iam_policy.allow_unauthenticated_invocations.policy_data
  project     = google_cloud_run_v2_service.web_django.project
  service     = google_cloud_run_v2_service.web_django.name
}


resource "google_cloud_run_v2_job" "web_django_management" {
  depends_on = [google_project_service.run_googleapis_com, google_artifact_registry_repository_iam_member.cr_sa]

  name         = "web-django-management"
  location     = var.google_region_prod
  launch_stage = "BETA"

  template {
    template {
      containers {
        env {
          name  = "DJANGO_DONT_START_SERVER"
          value = "true"
        }
        env {
          name  = "DJANGO_MANAGEPY_COLLECTSTATIC"
          value = "true"
        }
        env {
          name  = "DJANGO_MANAGEPY_MIGRATE"
          value = "true"
        }
        env {
          name  = "ENVIRONMENT"
          value = "prod"
        }
        image = local.cloud_run_image
        ports {
          container_port = 8080
          name           = "http1"
        }
        volume_mounts {
          name       = "cloudsql"
          mount_path = "/cloudsql"
        }
      }
      service_account = google_service_account.web_prod.email
      volumes {
        name = "cloudsql"
        cloud_sql_instance {
          instances = [google_sql_database_instance.prod.connection_name]
        }
      }
    }
  }
}

resource "null_resource" "web_django_management_execution" {
  provisioner "local-exec" {
    command = "gcloud beta run jobs execute ${google_cloud_run_v2_job.web_django_management.name} --project ${data.google_project.web_prod.project_id} --region ${google_cloud_run_v2_job.web_django_management.location} --wait"
  }
}
