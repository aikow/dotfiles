# Set up automatic ls on cd
auto_ls() {
  emulate -L zsh
  echo
  if command -v eza &>/dev/null; then
    eza --icons -a --group-directories-first
  else
    ls -AG --color=always
  fi
}

# Check if auto-ls has already been added to the chpwd_functions array. This
# ensures that resourcing the zshrc file doesnt cause ls to be run twice.
if [[ ! "${chpwd_functions[*]}" =~ "auto_ls" ]]; then
  chpwd_functions=(auto_ls $chpwd_functions)
fi
