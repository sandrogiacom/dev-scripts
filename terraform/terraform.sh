#!/usr/bin/env bash
echo ==============================
echo install terraform
echo ==============================
wget https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip
unzip terraform_1.0.9_linux_amd64.zip
chmod +x ./terraform
sudo mv ./terraform /usr/local/bin/terraform
rm terraform_1.0.9_linux_amd64.zip
echo ==============================
echo install finished!
