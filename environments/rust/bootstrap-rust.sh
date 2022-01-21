readonly CARGO_HOME=~/.cargo

if [[ ! -d "${CARGO_HOME}" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

