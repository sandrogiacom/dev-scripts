#!/usr/bin/env bash
echo ==============================
echo install docker
echo ==============================
apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu artful stable" && \
apt-get update && \
apt-get install -y docker-ce

echo ==============================
echo add docker root
echo ==============================
groupadd docker && \
usermod -aG docker $USER

echo ==============================
echo install docker-compose
echo ==============================
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose
