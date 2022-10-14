resource "google_storage_bucket" "django_static_assets" {
  force_destroy               = true
  location                    = var.google_region_prod
  name                        = "${var.google_project_id_prod}-static"
  project                     = var.google_project_id_prod
  uniform_bucket_level_access = false

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_binding" "public" {
  bucket  = google_storage_bucket.django_static_assets.name
  members = ["allUsers"]
  role    = "roles/storage.legacyObjectReader"
}

resource "google_storage_bucket_iam_binding" "web_prod_sa" {
  bucket  = google_storage_bucket.django_static_assets.name
  members = [google_service_account.web_prod.member]
  role    = "roles/storage.admin"
}
