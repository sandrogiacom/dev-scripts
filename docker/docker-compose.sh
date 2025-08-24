#!/usr/bin/env bash
set -euo pipefail

echo "=============================="
echo "Install/Update Docker Compose (Ubuntu/Debian)"
echo "=============================="

if command -v apt-get >/dev/null 2>&1; then
  # Update package index and install prerequisites
  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  # Ensure Docker's official GPG key and repository are configured
  sudo install -m 0755 -d /etc/apt/keyrings
  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || true
  fi
  sudo chmod a+r /etc/apt/keyrings/docker.gpg || true

  UBUNTU_CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$(lsb_release -cs)}")"
  ARCH="$(dpkg --print-architecture)"
  echo "Using Ubuntu codename: $UBUNTU_CODENAME, arch: $ARCH"

  echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || true

  sudo apt-get update

  # Remove legacy docker-compose v1 if present to avoid conflicts
  sudo apt-get remove -y docker-compose || true

  # Install Compose v2 plugin
  sudo apt-get install -y docker-compose-plugin
else
  echo "apt-get not found; attempting to install Docker Compose v2 via GitHub release" >&2

  uname_s=$(uname -s | tr '[:upper:]' '[:lower:]')
  uname_m=$(uname -m)
  case "$uname_m" in
    x86_64|amd64) arch="x86_64" ;;
    aarch64|arm64) arch="aarch64" ;;
    armv7l) arch="armv7" ;;
    *) echo "Unsupported architecture: $uname_m" >&2; exit 1 ;;
  esac

  # Get latest release tag from GitHub
  latest=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | grep -oE '"tag_name":\s*"v[^"]+"' | head -n1 | sed -E 's/.*"v([^"]+)".*/\1/')
  if [ -z "${latest:-}" ]; then
    echo "Failed to determine latest Docker Compose version from GitHub" >&2
    exit 1
  fi
  echo "Latest Compose version: $latest"

  sudo mkdir -p /usr/local/lib/docker/cli-plugins
  url="https://github.com/docker/compose/releases/download/v${latest}/docker-compose-${uname_s}-${arch}"
  echo "Downloading: $url"
  curl -fL "$url" -o /tmp/docker-compose
  sudo install -m 0755 /tmp/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
  rm -f /tmp/docker-compose
fi

# Create backward-compatible docker-compose shim if needed
if ! command -v docker-compose >/dev/null 2>&1; then
  if command -v docker >/dev/null 2>&1; then
    echo "Creating docker-compose shim at /usr/local/bin/docker-compose"
    sudo tee /usr/local/bin/docker-compose >/dev/null <<'EOF'
#!/usr/bin/env bash
exec docker compose "$@"
EOF
    sudo chmod +x /usr/local/bin/docker-compose
  fi
fi

# Validation
echo "=============================="
echo "Validation"
echo "=============================="
if command -v docker >/dev/null 2>&1; then
  if ! docker compose version; then
    echo "Docker Compose (v2) not found or failed to run" >&2
    exit 1
  fi
else
  if command -v docker-compose >/dev/null 2>&1; then
    docker-compose version || true
  else
    echo "Neither docker nor docker-compose is available in PATH" >&2
    exit 1
  fi
fi

echo "=============================="
echo "Done."
