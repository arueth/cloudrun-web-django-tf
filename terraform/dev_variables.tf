variable "cloudrun_web_django_additional_hosts_dev" {
  type        = string
  default     = ""
  description = "Comma seperated list of additonal hostnames for development"
}

variable "cloudrun_image_tag_dev" {
  type        = string
  description = "Cloud Run image tag in development"
}

variable "google_billing_account_dev" {
  type        = string
  description = "The Google Cloud Development billing account ID"
}

variable "google_project_folder_id_dev" {
  type        = string
  description = "The Google Cloud Development project's folder ID"
}

variable "google_project_id_dev" {
  type        = string
  description = "The Google Cloud Development project ID"
}

variable "google_region_dev" {
  type        = string
  description = "The Google Cloud Development default region"
}

variable "google_zone_dev" {
  type        = string
  description = "The Google Cloud Development default zone"
}
