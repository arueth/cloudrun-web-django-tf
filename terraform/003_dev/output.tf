output "cloud_run_url_dev" {
  value = google_cloud_run_v2_service.web_django.uri
}
