resource "google_project_service" "secretmanager_googleapis_com" {
  disable_on_destroy = true
  service            = "secretmanager.googleapis.com"
}

###############################################################################
# DJANGO SETTINGS SECRET
###############################################################################
resource "random_password" "django_secret_key_dev" {
  length           = 50
  special          = true
  override_special = "!@#$%^&*(-_=+)"
}

resource "google_secret_manager_secret" "django_settings_dev" {
  depends_on = [google_project_service.secretmanager_googleapis_com]

  secret_id = "django_settings"

  labels = {
    "environment" : "dev"
  }
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "django_settings_dev" {
  secret = google_secret_manager_secret.django_settings_dev.id
  secret_data = templatefile(
    "../${path.module}/003_dev/templates/django_settings.tftpl",
    {
      additional_hosts  = var.cloudrun_web_django_additional_hosts_dev
      database_url      = "postgres://${google_sql_user.django.name}:${random_password.db_password.result}@//cloudsql/${google_sql_database_instance.dev.connection_name}/${google_sql_database.django.name}"
      static_bucket_url = google_storage_bucket.django_static_assets.name
      django_secret_key = random_password.django_secret_key_dev.result
    }
  )
}

resource "google_secret_manager_secret_iam_binding" "django_settings_dev_web_dev_sa" {
  members   = [google_service_account.web_dev.member]
  project   = google_secret_manager_secret.django_settings_dev.project
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.django_settings_dev.secret_id
}

###############################################################################
# DJANGO ADMIN PASSWORD SECRET
###############################################################################
resource "random_password" "django_admin_password_dev" {
  length           = 30
  special          = true
  override_special = "!@#$%^&*(-_=+)"
}

resource "google_secret_manager_secret" "django_admin_password_dev" {
  depends_on = [google_project_service.secretmanager_googleapis_com]

  secret_id = "django_admin_password"

  labels = {
    "environment" : "dev"
  }
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "django_admin_password_dev" {
  secret      = google_secret_manager_secret.django_admin_password_dev.id
  secret_data = random_password.django_admin_password_dev.result
}

resource "google_secret_manager_secret_iam_binding" "django_admin_password_dev_web_dev_sa" {
  members   = [google_service_account.web_dev.member]
  project   = google_secret_manager_secret.django_admin_password_dev.project
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.django_admin_password_dev.secret_id
}
