#!/usr/bin/env bash
set -euo pipefail

#
# Instalador/Atualizador do Terraform
# - Detecta SO e arquitetura (Linux/Darwin; amd64/arm64)
# - Escolhe versão via TERRAFORM_VERSION ou pega a última (HashiCorp checkpoint API)
# - Verifica checksum SHA256
# - Instala em /usr/local/bin (ou $INSTALL_DIR) usando sudo somente se necessário
# - Idempotente: não baixa se já estiver na versão desejada
#

banner() {
  echo "=============================="
  echo "$1"
  echo "=============================="
}

err() {
  echo "[ERRO] $*" >&2
}

have() {
  command -v "$1" >/dev/null 2>&1
}

fetch() {
  local url="$1" out="$2"
  if have curl; then
    curl -fsSL "$url" -o "$out"
  elif have wget; then
    wget -q "$url" -O "$out"
  else
    err "Nem curl nem wget encontrados. Instale um deles e tente novamente. Ex.: sudo apt install curl"
    exit 1
  fi
}

banner "Instalar/Atualizar Terraform"

# Detecta SO e arquitetura
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
  x86_64|amd64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  armv7l) ARCH=arm ;;
  *) err "Arquitetura não suportada: $ARCH"; exit 1 ;;
esac

if [[ "$OS" != "linux" && "$OS" != "darwin" ]]; then
  err "Sistema operacional não suportado: $OS"
  exit 1
fi

# Dependências básicas
if ! have unzip; then
  err "Dependência ausente: unzip. Instale e tente novamente (ex.: sudo apt install unzip)."
  exit 1
fi

# Resolve versão alvo
TARGET_VERSION="${TERRAFORM_VERSION:-}"
if [[ -z "$TARGET_VERSION" ]]; then
  # Obtem versão mais recente via checkpoint API (sem jq)
  if have curl || have wget; then
    RESP=$( (have curl && curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/terraform) || (have wget && wget -qO- https://checkpoint-api.hashicorp.com/v1/check/terraform) || true )
    TARGET_VERSION=$(printf '%s' "$RESP" | sed -n 's/.*"current_version":"\([^"]\+\)".*/\1/p') || true
  fi
fi

if [[ -z "$TARGET_VERSION" ]]; then
  err "Não foi possível determinar a última versão do Terraform. Defina a variável TERRAFORM_VERSION (ex.: 1.9.5) e tente novamente."
  exit 1
fi

ZIP_NAME="terraform_${TARGET_VERSION}_${OS}_${ARCH}.zip"
SUMS_NAME="terraform_${TARGET_VERSION}_SHA256SUMS"
BASE_URL="https://releases.hashicorp.com/terraform/${TARGET_VERSION}"
ZIP_URL="${BASE_URL}/${ZIP_NAME}"
SUMS_URL="${BASE_URL}/${SUMS_NAME}"

# Idempotência: verifica versão instalada
if have terraform; then
  INSTALLED_VERSION=$(terraform version 2>/dev/null | head -n1 | sed -n 's/^Terraform v\([0-9.]*\).*/\1/p')
  if [[ "$INSTALLED_VERSION" == "$TARGET_VERSION" ]]; then
    banner "Terraform já está na versão $INSTALLED_VERSION. Nada a fazer."
    exit 0
  else
    echo "Versão instalada: $INSTALLED_VERSION (alvo: $TARGET_VERSION)"
  fi
fi

# Diretório de instalação
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
SUDO=""
if [[ ! -w "$INSTALL_DIR" ]]; then
  if have sudo; then SUDO=sudo; else err "Sem permissão para escrever em $INSTALL_DIR e 'sudo' não encontrado."; exit 1; fi
fi

# Trabalho em diretório temporário
TMPDIR=$(mktemp -d)
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT
cd "$TMPDIR"

banner "Baixando Terraform $TARGET_VERSION para $OS/$ARCH"
fetch "$ZIP_URL" "$ZIP_NAME"
fetch "$SUMS_URL" "$SUMS_NAME"

# Verificação de checksum
banner "Verificando checksum"
if have sha256sum; then
  grep " $ZIP_NAME" "$SUMS_NAME" | sha256sum -c -
elif have shasum; then
  EXPECTED=$(grep " $ZIP_NAME" "$SUMS_NAME" | awk '{print $1}')
  echo "$EXPECTED  $ZIP_NAME" | shasum -a 256 -c -
else
  echo "[AVISO] Nem sha256sum nem shasum encontrados. Pulando verificação de checksum."
fi

banner "Instalando Terraform $TARGET_VERSION"
unzip -o "$ZIP_NAME" >/dev/null
$SUDO install -m 0755 terraform "$INSTALL_DIR/terraform"

# Confirma
if have terraform; then
  echo "Instalação concluída: $(terraform version | head -n1)"
else
  err "Falha na instalação do terraform em $INSTALL_DIR"
  exit 1
fi

banner "Concluído"
