#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASE_PATH=${SCRIPT_PATH%/*}

cd ${BASE_PATH}

sed -i "s/deletion_protection = true/deletion_protection = false/" ${BASE_PATH}/terraform/003_dev/cloud_sql.tf && \
cd ${BASE_PATH}/terraform/003_dev && \
terraform init && \
terraform plan -input=false -out=tfplan && \
terraform apply tfplan && \
cd ${BASE_PATH}/terraform/003_dev && \
terraform init && \
terraform destroy -auto-approve && \
sed -i "s/deletion_protection = true/deletion_protection = false/" ${BASE_PATH}/terraform/004_stage/cloud_sql.tf && \
cd ${BASE_PATH}/terraform/004_stage && \
terraform init && \
terraform plan -input=false -out=tfplan && \
terraform apply tfplan && \
cd ${BASE_PATH}/terraform/004_stage && \
terraform init && \
terraform destroy -auto-approve && \
sed -i "s/deletion_protection = true/deletion_protection = false/" ${BASE_PATH}/terraform/005_prod/cloud_sql.tf && \
cd ${BASE_PATH}/terraform/005_prod && \
terraform init && \
terraform plan -input=false -out=tfplan && \
terraform apply tfplan && \
cd ${BASE_PATH}/terraform/005_prod && \
terraform init && \
terraform destroy -auto-approve && \
cd ${BASE_PATH}/terraform/002_shared && \
terraform init && \
terraform destroy -auto-approve && \
sed -i "s/force_destroy               = false/force_destroy               = true/" ${BASE_PATH}/terraform/001_initialize/cloud_storage.tf && \
sed -i "s/skip_delete     = true/skip_delete     = false/" ${BASE_PATH}/terraform/001_initialize/project.tf && \
cd ${BASE_PATH}/terraform/001_initialize && \
terraform init && \
terraform plan -input=false -out=tfplan && \
terraform apply tfplan && \
export CR_WEB_DJANGO_TF_SHARED_PROJECT_ID=$(grep google_project_id_shared ${BASE_PATH}/terraform/shared.auto.tfvars | awk -F"=" '{print $2}' | xargs) && \
cd ${BASE_PATH}/terraform/001_initialize && \
gsutil cp gs://${CR_WEB_DJANGO_TF_SHARED_PROJECT_ID}/terraform/initialize/state/default.tfstate ${BASE_PATH}/terraform/001_initialize/state/ && \
mv versions.tf.orig versions.tf && \
terraform init -migrate-state && \
cd ${BASE_PATH}/terraform/001_initialize && \
terraform init && \
terraform destroy -auto-approve
