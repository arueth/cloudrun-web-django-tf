resource "google_storage_bucket" "web_shared" {
  force_destroy               = false
  location                    = var.google_region_shared
  name                        = var.google_project_id_shared
  project                     = google_project.web_shared.project_id
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
