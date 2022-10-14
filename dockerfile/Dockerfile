FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:410.0.0-alpine

ENV TERRAFORM_VERSION=1.3.5

RUN echo "INSTALL TERRAFORM v${TERRAFORM_VERSION}" \
&& wget -q -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip terraform.zip \
&& chmod +x terraform \
&& mv terraform /usr/local/bin \
&& rm -rf terraform.zip

RUN echo "INSTALL ADDITIONAL GCLOUD COMPONENTS" \
&& gcloud components install \
beta \
&& rm -rf $(find google-cloud-sdk/ -regex ".*/__pycache__") \
&& rm -rf google-cloud-sdk/.install/.backup
