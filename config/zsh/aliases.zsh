# --------------
# |   Config   |
# --------------
alias zshconfig="${EDITOR} ~/.zshrc"
alias dotfiles="${EDITOR} ~/.dotfiles/"

# ----------
# |   cd   |
# ----------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ----------
# |   ls   |
# ----------
if command -v exa &>/dev/null; then
  alias l='exa --group-directories-first'
  alias ls='exa --group-directories-first --icons'
  alias lg='exa -l --group-directories-first --icons --git'
  alias lt='exa --group-directories-first --tree --icons'
  alias ll='exa -l --group-directories-first --icons'
  alias lll='exa -la --group-directories-first --icons --group'
else
  alias l='ls'
  alias ll='ls -l'
  alias lll='ls -lA'
fi

alias grep='grep -i --color=auto'

# --------------
# |   Docker   |
# --------------
# Run a container
alias drun='docker run --rm'

# Run an interactive container
alias druni='docker run --rm -it'

# Run an interactive container with the current working directory mounted to
# /mnt/local.
alias druniv='docker run --rm -it -v $(pwd):/mnt/local'
