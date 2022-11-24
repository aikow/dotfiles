#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

IFS=$' \n\t'

readonly DIRNAME="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

readonly OS="$(uname -s)" 
readonly BIN_DIR="${DIRNAME}/bin"

case "${OS}" in
  Darwin)
    ln -s "${DIRNAME}/macos" "${BIN_DIR}"
    ;;
  *)
    echo "No scripts for ${OS}"
    ;;
esac
