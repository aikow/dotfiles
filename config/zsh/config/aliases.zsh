## Dots ##
alias zshconfig='${EDITOR} ~/.zshrc'
alias lzshconfig='${EDITOR} ~/.local/config/zsh/zshrc'
alias zshreload='source ~/.zshenv; source ~/.zshrc'

source $DOTFILES/config/bash/config/aliases.bash

cdp() {
  project="$(projects | fzf --ansi)"
  if [[ $? -eq 0 ]]; then
    cd "$project"
  fi
}

