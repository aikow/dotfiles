# --------------
# |   Config   |
# --------------
alias dotfiles='$EDITOR ~/.dotfiles/'
alias ldotfiles='$EDITOR ~/.local/config/'

## Cd ##
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

## Eza ##
alias l='eza --group-directories-first --icons=auto'
alias lg='eza --group-directories-first --icons=auto --long --almost-all --git'
alias ll='eza --group-directories-first --icons=auto --long'
alias lll='eza --group-directories-first --icons=auto --long --almost-all --group --links --header'
alias lt='eza --group-directories-first --icons=auto --tree'
alias lti='eza --group-directories-first --icons=auto --tree --git-ignore'

## Docker ##
alias d='docker'
alias dc='docker container'
alias di='docker image'
alias dn='docker network'
alias dps='docker ps'
alias dv='docker volume'

alias dcl='docker container ls --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Command}}"'
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

## Jujutsu ##
alias jb='jj bookmark'
alias jba='jj bookmark advance -t @-'
alias jbm='jj bookmark move -t @-'
alias jc='jj commit'
alias ji='jj --ignore-working-copy status'
alias jil='jj --ignore-working-copy log'
alias jjgf='jj git fetch'
alias jjgp='jj git push'
alias jk='jj status'
alias jl='jj log'
alias jlc='jj log --template=builtin_log_compact_full_description'
alias jld='jj log --template=builtin_log_detailed'
alias jlo='jj log --template=builtin_log_oneline'

## Julia ##
alias j.='julia --project=.'

## Kubernetes ##
alias k='kubernetes'
