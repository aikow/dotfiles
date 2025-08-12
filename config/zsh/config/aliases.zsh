## Dots ##
alias zshconfig='${EDITOR} ~/.zshrc'
alias lzshconfig='${EDITOR} ~/.local/config/zsh/zshrc'
alias zshreload='source ~/.zshenv; source ~/.zshrc'
alias dotfiles='${EDITOR} ~/.dotfiles/'
alias ldotfiles='${EDITOR} ~/.local/config/'

## cd ##
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

## ls / eza ##
if command -v eza &>/dev/null; then
    alias l='eza'
    alias ls='eza --group-directories-first --icons=auto'
    alias lg='eza --group-directories-first --icons=auto --git'
    alias lt='eza --group-directories-first --icons=auto --tree'
    alias ll='eza --group-directories-first --icons=auto --long'
    alias lll='eza --group-directories-first --icons=auto --long --almost-all --group --links --header'
else
  alias l='ls'
  alias ll='ls -l'
  alias lll='ls -lA'
fi

alias grep='grep -i --color=auto'

## Docker ##
alias drun='docker run --rm'
alias druni='docker run --rm -it'
alias druniv='docker run --rm -it -v $(pwd):/mnt/local'
alias drunip='docker run --rm -it -v $(pwd):/mnt/local -w /mnt/local'

## Git ##
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gl='git pull'
alias gp='git push'
alias gr='git reset'
alias grs='git restore'
alias gst='git status'
alias gsw='git switch'
alias gw='git worktree'
