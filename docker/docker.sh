#!/usr/bin/env bash
set -euo pipefail

echo "=============================="
echo "Validate and install/update Docker (Ubuntu)"
echo "=============================="

# Update package index and install prerequisites
sudo apt-get update
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Set up Docker's official GPG key and repository
sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi
sudo chmod a+r /etc/apt/keyrings/docker.gpg

UBUNTU_CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$(lsb_release -cs)}")"
ARCH="$(dpkg --print-architecture)"
echo "Using Ubuntu codename: $UBUNTU_CODENAME, arch: $ARCH"

echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Remove potentially conflicting packages (if present)
sudo apt-get remove -y docker docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true

# Install or upgrade Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker service if systemd is available
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl enable docker >/dev/null 2>&1 || true
  sudo systemctl restart docker || sudo systemctl start docker || true
fi

# Manage docker group and add current (non-root) user
sudo groupadd -f docker
TARGET_USER="${SUDO_USER:-$USER}"
if ! id -nG "$TARGET_USER" | grep -qw docker; then
  sudo usermod -aG docker "$TARGET_USER"
  ADDED_GROUP="yes"
else
  ADDED_GROUP="no"
fi

# Validation
echo "=============================="
echo "Validation"
echo "=============================="
if ! docker --version; then
  echo "Docker CLI not found" >&2
  exit 1
fi
if ! docker compose version; then
  echo "Docker Compose plugin not found" >&2
  exit 1
fi
containerd --version || true

if command -v systemctl >/dev/null 2>&1; then
  if ! sudo systemctl is-active --quiet docker; then
    echo "Docker service is not active. Attempting to start..."
    sudo systemctl start docker || true
  fi
fi

echo "=============================="
echo "Done."
if [ "$ADDED_GROUP" = "yes" ]; then
  echo "User '$TARGET_USER' was added to 'docker' group. Log out and log in again (or run: newgrp docker) for the change to take effect."
fi


