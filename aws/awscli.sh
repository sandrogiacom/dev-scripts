#!/usr/bin/env bash
set -euo pipefail

#
# Instalador/Atualizador do AWS CLI v2 (mais recente)
# - Detecta SO e arquitetura (Linux/Darwin; amd64/arm64)
# - Usa URLs oficiais "latest" da AWS para sempre obter a versão mais nova
# - Instala em /usr/local/bin (ou $INSTALL_BIN_DIR) usando sudo somente se necessário
# - Idempotente: usa --update no instalador (só atualiza se necessário)
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

banner "Instalar/Atualizar AWS CLI v2"

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

# Diretórios de instalação (podem ser sobrescritos por variáveis de ambiente)
INSTALL_BIN_DIR="${INSTALL_BIN_DIR:-/usr/local/bin}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/aws-cli}"
SUDO=""
if [[ ! -w "$INSTALL_BIN_DIR" || ! -w "$(dirname "$INSTALL_DIR")" ]]; then
  if have sudo; then SUDO=sudo; else err "Sem permissão para escrever em $INSTALL_BIN_DIR ou $(dirname "$INSTALL_DIR") e 'sudo' não encontrado."; exit 1; fi
fi

# Idempotência: se já existe, mostra versão atual
if have aws; then
  echo "Versão instalada: $(aws --version 2>&1)"
fi

# Trabalho em diretório temporário
TMPDIR=$(mktemp -d)
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT
cd "$TMPDIR"

if [[ "$OS" == "linux" ]]; then
  # Dependências básicas
  if ! have unzip; then
    err "Dependência ausente: unzip. Instale e tente novamente (ex.: sudo apt install unzip)."
    exit 1
  fi

  case "$ARCH" in
    amd64) AWS_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" ;;
    arm64) AWS_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" ;;
    *) err "Arquitetura Linux não suportada para AWS CLI v2: $ARCH"; exit 1 ;;
  esac

  banner "Baixando AWS CLI v2 para Linux/$ARCH"
  fetch "$AWS_URL" "awscliv2.zip"

  banner "Instalando AWS CLI v2"
  unzip -o awscliv2.zip >/dev/null
  # O instalador criará/atualizará os destinos informados
  $SUDO ./aws/install --bin-dir "$INSTALL_BIN_DIR" --install-dir "$INSTALL_DIR" --update

elif [[ "$OS" == "darwin" ]]; then
  # macOS: pacote universal .pkg
  AWS_URL="https://awscli.amazonaws.com/AWSCLIV2.pkg"
  banner "Baixando AWS CLI v2 para macOS (pkg)"
  fetch "$AWS_URL" "AWSCLIV2.pkg"

  banner "Instalando AWS CLI v2 (macOS)"
  # O instalador do macOS requer privilégios para instalar em /usr/local/aws-cli e /usr/local/bin
  if [[ -z "$SUDO" ]]; then
    # Verifica permissão do destino; se não houver, usa sudo
    if [[ ! -w "/usr/local" || ! -w "/usr/local/bin" ]]; then
      if have sudo; then SUDO=sudo; else err "Permissão insuficiente para instalar no macOS e 'sudo' não encontrado."; exit 1; fi
    fi
  fi
  $SUDO installer -pkg "AWSCLIV2.pkg" -target /
fi

# Confirma
if have aws; then
  banner "Instalação concluída"
  aws --version 2>&1 || true
else
  err "Falha na instalação do AWS CLI v2 em $INSTALL_BIN_DIR"
  exit 1
fi
