# Terraform Coding Guide

## File Layout

Use several files to logically split up the code:

- `main.tf` - call modules ,locals, and data sources for resources. Logical groupings of resources with their own files and descriptive names can be created for similar resources.
- `*variables.tf` - contains declarations of variables used in main.tf
- `outputs.tf` - contains outputs from the resources created in main.tf
- `versions.tf` - contains version requirements for Terraform and providers
- `*.auto.tfvars` - should only be used for composition

## Naming Conventions

- Name all configuration objects using underscores to delimit multiple words.

  `resource "google_compute_instance" "web_server"`  
  _instead of:_  
  `resource "google_compute_instance" "web-server"`

- In the resource name, don't repeat the resource type.

  `resource "google_compute_global_address" "main"`  
  _instead of:_  
  `resource "google_compute_global_address" "main_global_address"`

## References

- [Google Cloud best practices for using Terraform](https://cloud.google.com/docs/terraform/best-practices-for-terraform)
