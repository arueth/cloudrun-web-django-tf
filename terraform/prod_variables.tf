variable "cloudrun_web_django_additional_hosts_prod" {
  type        = string
  default     = ""
  description = "Comma seperated list of additonal hostnames for production"
}

variable "cloudrun_image_tag_prod" {
  type        = string
  description = "Cloud Run image tag in production"
}

variable "google_billing_account_prod" {
  type        = string
  description = "The Google Cloud Production billing account ID"
}

variable "google_project_folder_id_prod" {
  type        = string
  description = "The Google Cloud Production project's folder ID"
}

variable "google_project_id_prod" {
  type        = string
  description = "The Google Cloud Production project ID"
}

variable "google_region_prod" {
  type        = string
  description = "The Google Cloud Production default region"
}

variable "google_zone_prod" {
  type        = string
  description = "The Google Cloud Production default zone"
}
