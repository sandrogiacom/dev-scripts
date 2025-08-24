#!/usr/bin/env bash
set -euo pipefail

echo ==============================
echo validate and update git
echo ==============================

if command -v git >/dev/null 2>&1; then
  echo "Git already installed: $(git --version)"
  echo "Updating git to the latest available version..."
  sudo apt-get update
  sudo apt-get install -y --only-upgrade git
else
  echo "Git not found. Installing..."
  sudo apt-get update
  sudo apt-get install -y git
fi

# Validate installation
if command -v git >/dev/null 2>&1; then
  echo "Git successfully installed/updated: $(git --version)"
else
  echo "Error: Git installation/upgrade failed." >&2
  exit 1
fi

echo ==============================
echo config git
echo ==============================
echo "git name, example: Lord Voldemort"
read -r gitName
git config --global user.name "$gitName"  && \
echo "git email, example: lord.voldemort@fluig.com"
read -r gitEmail
git config --global user.email "$gitEmail"  && \
git config --global core.precomposeunicode true  && \
git config --list

echo ==============================
echo git ssh key
echo ==============================
if [ -n "${gitEmail:-}" ]; then
  ssh-keygen -t rsa -C "$gitEmail"
else
  echo "Skipping SSH key generation because email was not provided."
fi
