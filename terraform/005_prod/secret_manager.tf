resource "google_project_service" "secretmanager_googleapis_com" {
  disable_on_destroy = true
  service            = "secretmanager.googleapis.com"
}

###############################################################################
# DJANGO SETTINGS SECRET
###############################################################################
resource "random_password" "django_secret_key_prod" {
  length           = 50
  special          = true
  override_special = "!@#$%^&*(-_=+)"
}

resource "google_secret_manager_secret" "django_settings_prod" {
  depends_on = [google_project_service.secretmanager_googleapis_com]

  secret_id = "django_settings"

  labels = {
    "environment" : "prod"
  }
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "django_settings_prod" {
  secret = google_secret_manager_secret.django_settings_prod.id
  secret_data = templatefile(
    "../${path.module}/005_prod/templates/django_settings.tftpl",
    {
      additional_hosts  = var.cloudrun_web_django_additional_hosts_prod
      database_url      = "postgres://${google_sql_user.django.name}:${random_password.db_password.result}@//cloudsql/${google_sql_database_instance.prod.connection_name}/${google_sql_database.django.name}"
      static_bucket_url = google_storage_bucket.django_static_assets.name
      django_secret_key = random_password.django_secret_key_prod.result
    }
  )
}

resource "google_secret_manager_secret_iam_binding" "django_settings_prod_web_prod_sa" {
  members   = [google_service_account.web_prod.member]
  project   = google_secret_manager_secret.django_settings_prod.project
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.django_settings_prod.secret_id
}

###############################################################################
# DJANGO ADMIN PASSWORD SECRET
###############################################################################
resource "random_password" "django_admin_password_prod" {
  length           = 30
  special          = true
  override_special = "!@#$%^&*(-_=+)"
}

resource "google_secret_manager_secret" "django_admin_password_prod" {
  depends_on = [google_project_service.secretmanager_googleapis_com]

  secret_id = "django_admin_password"

  labels = {
    "environment" : "prod"
  }
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "django_admin_password_prod" {
  secret      = google_secret_manager_secret.django_admin_password_prod.id
  secret_data = random_password.django_admin_password_prod.result
}

resource "google_secret_manager_secret_iam_binding" "django_admin_password_prod_web_prod_sa" {
  members   = [google_service_account.web_prod.member]
  project   = google_secret_manager_secret.django_admin_password_prod.project
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.django_admin_password_prod.secret_id
}
