#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Installs Miniconda3 4.6.14
# 
# Conda options
#     -b run install in batch mode (without manual intervention),
#                 it is expected the license terms are agreed upon
#     -f no error if install prefix already exists
#     -h print this help message and exit
#     -p PREFIX install prefix, defaults to /root/miniconda3, must not contain spaces.
#     -s skip running pre/post-link/install scripts
#     -u update an existing installation
#     -t run package tests after installation (may install conda-build)

readonly CONDA_INSTALL_DIR="${HOME}/.miniconda3"

if [[ -d "${CONDA_INSTALL_DIR}" ]]; then
  echo "Miniconda3 already installed"
else
  echo "Bootstrapping Miniconda3"
  mkdir -p "${CONDA_INSTALL_DIR}"

  # Get the correct miniconda source depending on the OS.
  if [[ $(uname) == Darwin ]]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O "${CONDA_INSTALL_DIR}/miniconda.sh"
  elif [[ $(uname) == Linux ]]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "${CONDA_INSTALL_DIR}/miniconda.sh"
  fi

  bash "${CONDA_INSTALL_DIR}/miniconda.sh" -b -u -p "${CONDA_INSTALL_DIR}"
  rm -rf "${CONDA_INSTALL_DIR}/miniconda.sh"
  "${CONDA_INSTALL_DIR}/bin/conda" init bash
  "${CONDA_INSTALL_DIR}/bin/conda" init zsh
fi
