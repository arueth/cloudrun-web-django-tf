# cloudrun-web-django-tf

## Requirements

Terraform `~> 1.3.5`

The `initialize` Terraform creates the initial resources and service accounts that will be used to provision and deploy all the environments.

The account that executes the `initialize` Terraform requires the following [Identity and Access Management (IAM)](https://cloud.google.com/iam) roles:

- `roles/resourcemanager.projectCreator` on the folders specified by `google_project_folder_id_shared`, `google_project_folder_id_dev`, `google_project_folder_id_stage`, and `google_project_folder_id_prod` in the `Setup` steps.
- `roles/billing.user` on the billing accounts specified by `google_billing_account_shared`, `google_billing_account_dev`, `google_billing_account_stage`, and `google_billing_account_prod` in the `Setup` steps.

## Setup

> For a list of what resources are created, see [What is created](docs/what_is_created.md)

- Setup `git`

  ```
  git config --global user.name "<Your Name>"
  git config --global user.email <Your Email>
  git config --global core.editor nano
  git config --global init.defaultBranch main
  ```

- Clone the source repository

  ```
  git clone https://github.com/arueth/cloudrun-web-django-tf.git && \
  cd cloudrun-web-django-tf && \
  git remote rename origin github && \
  git update-ref -d HEAD && \
  git rm --cached --ignore-unmatch --quiet -r * .[!.]*
  ```

- Set the required environment variable

  ```
  export CR_WEB_DJANGO_TF_BASE=$(pwd) && \
  echo "export CR_WEB_DJANGO_TF_BASE=${CR_WEB_DJANGO_TF_BASE}" >> ~/.profile
  ```

- Set the Shared environment's variables in the [shared.auto.tfvars](terraform/shared.auto.tfvars) file

  ```
  vi ${CR_WEB_DJANGO_TF_BASE}/terraform/shared.auto.tfvars
  ```

  ```
  google_billing_account_shared   = "<Shared Billing Account ID>"
  google_project_folder_id_shared = "<Shared Project's Folder ID>"
  google_project_id_shared        = "<Shared Project ID>"
  google_region_shared            = "<Shared Default Region>"
  google_zone_shared              = "<Shared Default Zone>"
  ```

- Set the Development environment's variables in the [dev.auto.tfvars](terraform/dev.auto.tfvars) file

  ```
  vi ${CR_WEB_DJANGO_TF_BASE}/terraform/dev.auto.tfvars
  ```

  ```
  google_billing_account_dev   = "<Development Billing Account ID>"
  google_project_folder_id_dev = "<Development Project's Folder ID>"
  google_project_id_dev        = "<Development Project ID>"
  google_region_dev            = "<Development Default Region>"
  google_zone_dev              = "<Development Default Zone>"
  ```

- Set the Staging environment's variables in the [stage.auto.tfvars](terraform/stage.auto.tfvars) file

  ```
  vi ${CR_WEB_DJANGO_TF_BASE}/terraform/stage.auto.tfvars
  ```

  ```
  google_billing_account_stage   = "<Staging Billing Account ID>"
  google_project_folder_id_stage = "<Staging Project's Folder ID>"
  google_project_id_stage        = "<Staging Project ID>"
  google_region_stage            = "<Staging Default Region>"
  google_zone_stage              = "<Staging Default Zone>"
  ```

- Set the Production environment's variables in the [prod.auto.tfvars](terraform/prod.auto.tfvars) file

  ```
  vi ${CR_WEB_DJANGO_TF_BASE}/terraform/prod.auto.tfvars
  ```

  ```
  google_billing_account_prod   = "<Production Billing Account ID>"
  google_project_folder_id_prod = "<Production Project's Folder ID>"
  google_project_id_prod        = "<Production Project ID>"
  google_region_prod            = "<Production Default Region>"
  google_zone_prod              = "<Production Default Zone>"
  ```

- Authenticate `gcloud` and set the application-default

  ```
  gcloud auth login --activate --no-launch-browser --quiet --update-adc
  ```

- Create and initialize the resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply -input=false tfplan
  ```

- Migrate the `tfstate` file to the bucket

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/001_initialize && \
  mv versions.tf versions.tf.orig && \
  mv versions.tf.new versions.tf && \
  terraform init -force-copy -migrate-state && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```

- Commit the updated `versions.tf` file and backup file

  ```
  cd ${CR_WEB_DJANGO_TF_BASE} && \
  git add terraform/001_initialize/versions.tf terraform/001_initialize/versions.tf.orig && \
  git commit -m 'Added updated versions.tf and backup file' && \
  git push csr main
  ```

- Wait for the [builds in the `global` region](https://console.cloud.google.com/cloud-build/builds;region=global) for each environment to complete

- Navigate to the `cloud_run_url_dev`, `cloud_run_url_stage`, and `cloud_run_url_prod` URLs output by their respective builds. You can also set the path to `/admin` and login to administrative console using the `django_admin_password` value from each environment.

## Cleanup

For steps to destroy the environment, see [Destroy the environments](docs/destroy.md)
