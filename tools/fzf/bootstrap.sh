#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ -d "${HOME}/.fzf" ]]; then
  exit
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

