#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASE_PATH=${SCRIPT_PATH%/*}

cd ${BASE_PATH}

cd ${BASE_PATH}/terraform/001_initialize && \
terraform init && \
terraform plan -input=false -out=tfplan && \
terraform apply -input=false tfplan && \
cd ${BASE_PATH}/terraform/001_initialize && \
mv versions.tf versions.tf.orig && \
mv versions.tf.new versions.tf && \
terraform init -force-copy -migrate-state && \
terraform plan -input=false -out=tfplan && \
terraform apply tfplan && \
cd ${BASE_PATH} && \
git add terraform/001_initialize/versions.tf terraform/001_initialize/versions.tf.orig && \
git commit -m 'Added updated versions.tf and backup file' && \
git push csr main
