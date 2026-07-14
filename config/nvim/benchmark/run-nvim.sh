#!/bin/sh
# Invoke Neovim in one of the two standard benchmark configurations.
set -euo pipefail

if [[ "$#" -ne 2 ]]; then
  echo "usage: $0 {configured|minimal} {FILE|-}" >&2
  exit 64
fi

mode=$1
file=$2
nvim_bin=${NVIM_BIN:-nvim}

case "$mode" in
  configured) set -- "$nvim_bin" --headless -n -i NONE ;;
  minimal) set -- "$nvim_bin" --headless -u NONE -U NONE -n -i NONE ;;
  *) echo "unknown mode: $mode" >&2; exit 64 ;;
esac

if [ "$file" != "-" ]; then set -- "$@" "$file"; fi
exec "$@" '+quitall!'
