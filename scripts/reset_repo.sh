#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASE_PATH=${SCRIPT_PATH%/*}

cd ${BASE_PATH}
git branch -u github/main
git remote remove csr

rm -rf ${BASE_PATH}/django

rm -rf ${BASE_PATH}/terraform/001_initialize/.terraform
rm -rf ${BASE_PATH}/terraform/001_initialize/state
rm -f ${BASE_PATH}/terraform/001_initialize/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/001_initialize/tfplan
rm -f ${BASE_PATH}/terraform/001_initialize/versions.tf.new
rm -f ${BASE_PATH}/terraform/001_initialize/versions.tf.orig

rm -rf ${BASE_PATH}/terraform/002_shared/.terraform
rm -f ${BASE_PATH}/terraform/002_shared/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/002_shared/tfplan
rm -f ${BASE_PATH}/terraform/002_shared/versions.tf

rm -rf ${BASE_PATH}/terraform/003_dev/.terraform
rm -f ${BASE_PATH}/terraform/003_dev/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/003_dev/tfplan
rm -f ${BASE_PATH}/terraform/003_dev/versions.tf

rm -rf ${BASE_PATH}/terraform/004_stage/.terraform
rm -f ${BASE_PATH}/terraform/004_stage/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/004_stage/tfplan
rm -f ${BASE_PATH}/terraform/004_stage/versions.tf

rm -rf ${BASE_PATH}/terraform/005_prod/.terraform
rm -f ${BASE_PATH}/terraform/005_prod/.terraform.lock.hcl
rm -f ${BASE_PATH}/terraform/005_prod/tfplan
rm -f ${BASE_PATH}/terraform/005_prod/versions.tf

git reset --hard github/main
