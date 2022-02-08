#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Check if FZF is already installed.
if command -v fzf &>/dev/null; then
  exit 0
fi

# If the FZF directory does not exist, then clone the rpeository and run the installer.
if [[ ! -d ~/.fzf ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
fi
