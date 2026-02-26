# --------------
# |   Config   |
# --------------
alias dotfiles='${EDITOR} ~/.dotfiles/'
alias ldotfiles='${EDITOR} ~/.local/config/'

## Cd ##
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

## Eza ##
alias l='eza --group-directories-first --icons=auto'
alias lg='eza --group-directories-first --icons=auto --long --almost-all --git'
alias lt='eza --group-directories-first --icons=auto --tree --git-ignore'
alias ll='eza --group-directories-first --icons=auto --long'
alias lll='eza --group-directories-first --icons=auto --long --almost-all --group --links --header'

## Docker ##
alias drun='docker run --rm'
alias druni='docker run --rm -it'
alias druniv='docker run --rm -it -v $(pwd):/mnt/local'
alias drunip='docker run --rm -it -v $(pwd):/mnt/local -w /mnt/local'

## Git ##
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gbi='git bisect'
alias gc='git commit'
alias gcb='git current-branch'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gcr='git current-repo'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias gm='git merge'
alias gmtl='git mergetool'
alias gmv='git mv'
alias gp='git push'
alias gr='git reset'
alias grb='git rebase'
alias grm='git rm'
alias gro='git remote'
alias grs='git restore'
alias grv='git revert'
alias gsa='git stash'
alias gsh='git show'
alias gst='git status'
alias gsw='git switch'
alias gt='git tag'
alias gw='git worktree'

## Jujutsi ##
alias jb='jj bookmark'
alias jbm='jj bookmark move -t @-'
alias jc='jj commit'
alias jk='jj status'
alias jl='jj log'
alias jjgf='jj git fetch'
alias jjgp='jj git push'

## Julia ##
alias j.='julia --project=.'
