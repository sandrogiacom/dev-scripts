#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Este script suporta apenas sistemas baseados em Debian/Ubuntu (requer apt-get)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo ====================================================
echo update ubuntu packages and install zsh, curl and git
echo ====================================================
sudo apt-get update -y
sudo apt-get install -y zsh curl git

echo ====================================================
echo validate zsh installation
echo ====================================================
if command -v zsh >/dev/null 2>&1; then
  echo "Zsh successfully installed: $(zsh --version)"
else
  echo "Error: Zsh installation failed." >&2
  exit 1
fi

echo ====================================================
echo set zsh as the default shell
echo ====================================================
ZSH_PATH="$(command -v zsh)"
if [ "${SHELL:-}" = "$ZSH_PATH" ]; then
  echo "Zsh is already the default shell."
else
  echo "Setting zsh as the default shell (may ask for your password)..."
  chsh -s "$ZSH_PATH" || echo "Warning: could not change the default shell automatically." >&2
fi

echo ====================================================
echo install oh-my-zsh
echo ====================================================
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh already installed at $HOME/.oh-my-zsh. Skipping."
else
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo ====================================================
echo validate oh-my-zsh installation
echo ====================================================
if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  echo "Oh My Zsh successfully installed."
else
  echo "Error: Oh My Zsh installation failed." >&2
  exit 1
fi

echo ====================================================
echo concluido
echo ====================================================
echo "Abra um novo terminal (ou rode 'source ~/.zshrc') para usar o Oh My Zsh."
