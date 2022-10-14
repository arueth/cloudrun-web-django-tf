resource "google_storage_bucket" "django_static_assets" {
  force_destroy               = true
  location                    = var.google_region_dev
  name                        = "${var.google_project_id_dev}-static"
  project                     = var.google_project_id_dev
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

resource "google_storage_bucket_iam_binding" "web_dev_sa" {
  bucket  = google_storage_bucket.django_static_assets.name
  members = [google_service_account.web_dev.member]
  role    = "roles/storage.admin"
}
