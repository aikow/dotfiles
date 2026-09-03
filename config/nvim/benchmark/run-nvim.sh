#!/usr/bin/env bash
# Invoke Neovim in one of the two standard benchmark configurations.
set -euo pipefail

if [[ "$#" -ne 3 ]]; then
  echo "usage: $0 {configured|minimal} {FILE|-} {none|default|SHADA_FILE}" >&2
  exit 64
fi

mode=$1
file=$2
shada=$3
nvim_bin=${NVIM_BIN:-nvim}

case "$mode" in
  configured) set -- "$nvim_bin" --headless -n ;;
  minimal) set -- "$nvim_bin" --headless -u NONE -U NONE -n ;;
  *) echo "unknown mode: $mode" >&2; exit 64 ;;
esac

case "$shada" in
  none) set -- "$@" -i NONE ;;
  default) : ;;  # Omit -i to load the normal per-user ShaDa file.
  *) set -- "$@" -i "$shada" ;;
esac

if [ "$file" != "-" ]; then set -- "$@" "$file"; fi
# This command runs after startup (and therefore after ShaDa is read), but
# before :quitall!, keeping benchmark repetitions from rewriting ShaDa.
if [[ "$shada" != none ]]; then set -- "$@" '+set shadafile=NONE'; fi
exec "$@" '+quitall!'
