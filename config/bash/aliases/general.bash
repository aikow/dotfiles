# --------------
# |   Config   |
# --------------
alias bashconfig='${EDITOR} ~/.zshrc'
alias dotfiles='${EDITOR} ~/.dotfiles/'

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
if command -v eza &>/dev/null; then
  alias l='eza --group-directories-first'
  alias ls='eza --group-directories-first --icons'
  alias lg='eza -l --group-directories-first --icons --git'
  alias lt='eza --group-directories-first --tree --icons'
  alias ll='eza -l --group-directories-first --icons'
  alias lll='eza -la --group-directories-first --icons --group'
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

# Run an interactive container with the current working directory mounted to
# /mnt/local and set the container working dir to that directory.
alias drunip='docker run --rm -it -v $(pwd):/mnt/local -w /mnt/local'
