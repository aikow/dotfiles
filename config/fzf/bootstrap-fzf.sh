#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Check if FZF is already installed.
if command -v fzf &>/dev/null; then
  exit 0
fi

install_dir="${HOME}/.local/share/fzf"

# Create the parent directory of the install dir.
mkdir -p "${install_dir%/*}"

# If the FZF directory does not exist, then clone the repository and run the
# installer.
if [[ ! -d "${install_dir}" ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "${install_dir}"
  "${install_dir}/install"
fi
