# Commands to run in interactive sessions can go here
if command -v exa &>/dev/null
  alias l='exa'
  alias ls='exa --group-directories-first --icons'
  alias lg='exa -l --group-directories-first --icons --git'
  alias ll='exa -l --group-directories-first --icons'
  alias lt='exa --group-directories-first --tree --level 2 --icons'
  alias lll='exa -la --group-directories-first --icons --group'
else
  alias l='ls'
  alias ll='ls -Al'
end

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

