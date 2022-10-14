# Manually build the environments

## Create the development project and resources

- Create the development project and resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/003_dev && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```

## Create the staging project and resources

- Create the staging project and resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/004_stage && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```

## Create the production project and resources

- Create the production project and resources

  ```
  cd ${CR_WEB_DJANGO_TF_BASE}/terraform/005_prod && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply tfplan
  ```
