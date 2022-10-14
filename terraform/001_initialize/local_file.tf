resource "local_file" "dev_versions_tf" {
  content = templatefile("../${path.module}/003_dev/templates/versions.tftpl",
  { google_storage_bucket_name = google_storage_bucket.web_shared.name })
  filename = "../${path.module}/003_dev/versions.tf"
}

resource "local_file" "initialize_versions_new_tf" {
  content = templatefile("../${path.module}/001_initialize/templates/versions.tftpl",
  { google_storage_bucket_name = google_storage_bucket.web_shared.name })
  filename = "../${path.module}/001_initialize/versions.tf.new"
}

resource "local_file" "prod_versions_tf" {
  content = templatefile("../${path.module}/005_prod/templates/versions.tftpl",
  { google_storage_bucket_name = google_storage_bucket.web_shared.name })
  filename = "../${path.module}/005_prod/versions.tf"
}

resource "local_file" "shared_versions_tf" {
  content = templatefile("../${path.module}/002_shared/templates/versions.tftpl",
  { google_storage_bucket_name = google_storage_bucket.web_shared.name })
  filename = "../${path.module}/002_shared/versions.tf"
}

resource "local_file" "stage_versions_tf" {
  content = templatefile("../${path.module}/004_stage/templates/versions.tftpl",
  { google_storage_bucket_name = google_storage_bucket.web_shared.name })
  filename = "../${path.module}/004_stage/versions.tf"
}
