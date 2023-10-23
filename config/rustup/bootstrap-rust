#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

#######################################################################
#                           Parse Arguments                           #
#######################################################################
#
declare -a POSITIONAL_ARGS=()
INSTALL="NO"
CARGO_HOME="${HOME}/.cargo"

while [[ $# -gt 0 ]]; do
  case $1 in
    -h | --cargo-home)
      CARGO_HOME="$2"
      shift # past argument
      shift # past value
      ;;
    -i | --install)
      INSTALL="YES"
      shift # past argument
      ;;
    -*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift                   # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]+"${POSITIONAL_ARGS[@]}"}" # restore positional parameters

#######################################################################
#                              Functions                              #
#######################################################################
#
# Checks that the given executable is installed.
#
# Arguments:
#   1. Program name used to find and install the program via cargo.
#   2. Program executable, used to run the program from the shell. If not
#      specified, the program name is the default value.
function check_install() {
  local prog_name="${1?Missing program name}"
  local prog_cmd="${2:-${prog_name}}"

  echo "Checking that ${prog_name} (${prog_cmd}) is installed..."

  if ! command -v "${prog_cmd}"; then
    echo "Installing ${prog_name} (${prog_cmd})"
    cargo install "${prog_name}"
  fi
}

#######################################################################
#                                Main                                 #
#######################################################################
#
# If the rust compiler is not installed and the directory does not exist, run
# the installer.
if ! command -v rustc &>/dev/null && [[ ! -d ${CARGO_HOME} ]]; then
  echo "Installing rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install the list of programs if the install flag is set.
if [[ ${INSTALL} == "YES" ]]; then
  echo "Checking that all programs are installed..."
  check_install ripgrep rg
  check_install git-delta delta
  check_install exa
  check_install fd-find fd
  check_install bat
  check_install hyperfine
fi
