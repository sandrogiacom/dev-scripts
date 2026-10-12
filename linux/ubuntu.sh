#!/usr/bin/env bash
set -euo pipefail

echo ==============================
echo atualizar e instalar pacotes essenciais
echo ==============================

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Este script suporta apenas sistemas baseados em Debian/Ubuntu (requer apt-get)."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Atualiza índices e instala pacotes úteis de base
sudo apt-get update -y
sudo apt-get install -y \
  software-properties-common \
  wget \
  curl \
  ca-certificates \
  gnupg \
  lsb-release \
  build-essential \
  unzip \
  zip \
  locales

# Locale padrão (pode ser sobrescrito via variável de ambiente)
TARGET_LOCALE="${LOCALE:-pt_BR.UTF-8}"

# Gera locales comuns (não falha se indisponível)
if command -v locale-gen >/dev/null 2>&1; then
  sudo locale-gen "$TARGET_LOCALE" en_US.UTF-8 || true
  sudo update-locale LANG="$TARGET_LOCALE" || true
fi

echo ==============================
echo concluido
echo ==============================
