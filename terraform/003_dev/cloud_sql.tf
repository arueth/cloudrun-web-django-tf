resource "google_project_service" "sqladmin_googleapis_com" {
  disable_dependent_services = true
  service                    = "sqladmin.googleapis.com"
}

resource "google_sql_database_instance" "dev" {
  depends_on = [google_project_service.sqladmin_googleapis_com]

  database_version    = "POSTGRES_14"
  deletion_protection = true
  name                = "web"
  region              = var.google_region_dev

  settings {
    availability_type = "ZONAL"
    tier              = "db-f1-micro"
  }
}

resource "google_sql_database" "django" {
  name     = "django"
  instance = google_sql_database_instance.dev.name
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!%*()-_{}<>"
}

resource "google_sql_user" "django" {
  name     = "django"
  instance = google_sql_database_instance.dev.name
  password = random_password.db_password.result
}

resource "google_project_iam_binding" "cloud_sql_client_web_dev_sa" {
  members = [google_service_account.web_dev.member]
  project = google_sql_database_instance.dev.project
  role    = "roles/cloudsql.client"
}
