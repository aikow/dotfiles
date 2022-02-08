#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly CARGO_HOME=~/.cargo

# Rust compile is already installed.
if command -v rustc &>/dev/null; then
  exit 0
fi

# If the directory does not exist, run the installer.
if [[ ! -d "${CARGO_HOME}" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

