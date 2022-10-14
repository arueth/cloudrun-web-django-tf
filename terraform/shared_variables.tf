variable "cloudrun_image_tag_default" {
  type        = string
  description = "Cloud Run image tag to use as default"
}

variable "google_billing_account_shared" {
  type        = string
  description = "The Google Cloud Shared billing account ID"
}

variable "google_project_folder_id_shared" {
  type        = string
  description = "The Google Cloud Shared project's folder ID"
}

variable "google_project_id_shared" {
  type        = string
  description = "The Google Cloud Shared project ID"
}

variable "google_region_shared" {
  type        = string
  description = "The Google Cloud Shared default region"
}

variable "google_zone_shared" {
  type        = string
  description = "The Google Cloud Shared default zone"
}

variable "source_git_clone_branch" {
  type        = string
  description = "Source git repository clone branch"
}

variable "source_git_clone_url" {
  type        = string
  description = "Source git repository clone URL"
}

variable "terraform_builder_image_tag_shared" {
  type        = string
  description = "Terraform builder image tag"
}
