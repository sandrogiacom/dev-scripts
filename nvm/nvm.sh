#!/usr/bin/env bash
set -euo pipefail

echo ====================================================
echo update ubuntu package to install curl
echo ====================================================
sudo apt update && sudo apt install -y curl

echo ====================================================
echo fetch the latest nvm version
echo ====================================================
NVM_VERSION="$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
  | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)"

if [ -z "${NVM_VERSION}" ]; then
  echo "Error: could not determine the latest NVM version." >&2
  exit 1
fi
echo "Latest NVM version: ${NVM_VERSION}"

echo ====================================================
echo install nvm
echo ====================================================
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

source "$NVM_DIR/nvm.sh"
nvm --version
