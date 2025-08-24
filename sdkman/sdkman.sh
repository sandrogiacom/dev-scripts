#!/usr/bin/env bash
echo ====================================================
echo update ubuntu package to install curl, unzip and zip
echo ====================================================
sudo apt update && sudo apt install curl unzip zip
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version