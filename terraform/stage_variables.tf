variable "cloudrun_web_django_additional_hosts_stage" {
  type        = string
  default     = ""
  description = "Comma seperated list of additonal hostnames for staging"
}

variable "cloudrun_image_tag_stage" {
  type        = string
  description = "Cloud Run image tag in staging"
}

variable "google_billing_account_stage" {
  type        = string
  description = "The Google Cloud Staging billing account ID"
}

variable "google_project_folder_id_stage" {
  type        = string
  description = "The Google Cloud Staging project's folder ID"
}

variable "google_project_id_stage" {
  type        = string
  description = "The Google Cloud Staging project ID"
}

variable "google_region_stage" {
  type        = string
  description = "The Google Cloud Staging default region"
}

variable "google_zone_stage" {
  type        = string
  description = "The Google Cloud Staging default zone"
}
