#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

IFS=$' \n\t'

export NO_INPUT=true
export NO_ANNEXES=true

if [[ ! -d ~/.local/share/zinit ]]; then
	bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi
