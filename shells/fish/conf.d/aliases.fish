# Commands to run in interactive sessions can go here
if command -v exa &>/dev/null
  alias l='exa'
  alias ls='exa -F'
  alias ll='exa -Fl'
  alias lg='exa -l --git'
  alias lt='exa --tree'
  alias lll='exa -Fla'
else
  alias l='ls'
  alias ll='ls -Al'
end

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

