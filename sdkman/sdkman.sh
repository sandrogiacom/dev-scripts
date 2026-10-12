#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Este script suporta apenas sistemas baseados em Debian/Ubuntu (requer apt-get)." >&2
  exit 1
fi

echo ====================================================
echo update ubuntu package to install curl, unzip and zip
echo ====================================================
sudo apt-get update -y
sudo apt-get install -y curl unzip zip

echo ====================================================
echo install sdkman
echo ====================================================
if [ -d "$HOME/.sdkman" ]; then
  echo "SDKMAN! already installed at $HOME/.sdkman. Skipping."
else
  curl -fsSL "https://get.sdkman.io" | bash
fi

echo ====================================================
echo validate sdkman installation
echo ====================================================
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk version
else
  echo "Error: SDKMAN! installation failed." >&2
  exit 1
fi

echo ====================================================
echo configure sdkman in shell rc files
echo ====================================================
SDKMAN_BLOCK_START="# >>> sdkman initialize >>>"
SDKMAN_BLOCK_END="# <<< sdkman initialize <<<"
SDKMAN_BLOCK="${SDKMAN_BLOCK_START}
export SDKMAN_DIR=\"\$HOME/.sdkman\"
[[ -s \"\$HOME/.sdkman/bin/sdkman-init.sh\" ]] && source \"\$HOME/.sdkman/bin/sdkman-init.sh\"
${SDKMAN_BLOCK_END}"

for RC_FILE in "$HOME/.zshrc" "$HOME/.bashrc"; do
  if [ -f "$RC_FILE" ] && ! grep -qF "$SDKMAN_BLOCK_START" "$RC_FILE"; then
    printf '\n%s\n' "$SDKMAN_BLOCK" >> "$RC_FILE"
    echo "SDKMAN! initialization added to $RC_FILE"
  else
    echo "SDKMAN! already configured in $RC_FILE (or file not found). Skipping."
  fi
done

echo ====================================================
echo concluido
echo ====================================================
echo "Abra um novo terminal (ou rode 'source ~/.zshrc') para usar o 'sdk'."
