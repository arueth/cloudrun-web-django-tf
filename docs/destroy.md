# Destroy the environments

## Destroy the development resources

- Disable `deletion_protection` on the database

  ```
  sed -i "s/deletion_protection = true/deletion_protection = false/" ${CR_WEB_DJANGO_TF_BASE}/terraform/003_dev/cloud_sql.tf && \
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/003_dev && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```

- Destroy the development resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/003_dev && \
  terraform init && \
  terraform destroy -auto-approve
  ```

## Destroy the staging resources

- Disable `deletion_protection` on the database

  ```
  sed -i "s/deletion_protection = true/deletion_protection = false/" ${CR_WEB_DJANGO_TF_BASE}/terraform/004_stage/cloud_sql.tf && \
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/004_stage && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```

- Destroy the staging resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/004_stage && \
  terraform init && \
  terraform destroy -auto-approve
  ```

## Destroy the production resources

- Disable `deletion_protection` on the database

  ```
  sed -i "s/deletion_protection = true/deletion_protection = false/" ${CR_WEB_DJANGO_TF_BASE}/terraform/005_prod/cloud_sql.tf && \
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/005_prod && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```

- Destroy the production resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/005_prod && \
  terraform init && \
  terraform destroy -auto-approve
  ```

## Destroy the shared resources

- Destroy the shared resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/002_shared && \
  terraform init && \
  terraform destroy -auto-approve
  ```

## Destroy the initialize resources

- Disable protection on the storage bucket and project

  ```
  sed -i "s/force_destroy               = false/force_destroy               = true/" ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize/cloud_storage.tf && \
  sed -i "s/skip_delete     = true/skip_delete     = false/" ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize/project.tf && \
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```

- Download the state file and migrate the backend

  ```
  export CR_WEB_DJANGO_TF_SHARED_PROJECT_ID=$(grep google_project_id_shared ${CR_WEB_DJANGO_TF_BASE}/terraform/shared.auto.tfvars | awk -F"=" '{print $2}' | xargs) && \
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize && \
  gsutil cp gs://${CR_WEB_DJANGO_TF_SHARED_PROJECT_ID}/terraform/initialize/state/default.tfstate ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize/state/ && \
  mv versions.tf.orig versions.tf && \
  terraform init -migrate-state
  ```

- Destroy the initialize resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize && \
  terraform init && \
  terraform destroy -auto-approve
  ```
