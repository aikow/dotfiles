## Config Shortcuts ##
alias fishconfig '$EDITOR ~/.config/fish/config.fish'
alias lfishconfig '$EDITOR ~/.local/config/fish/config.fish'
alias fishreload 'source ~/.config/fish/conf.d/*.fish; source ~/.config/fish/config.fish'

alias dotfiles '$EDITOR ~/.dotfiles/'
alias ldotfiles '$EDITOR ~/.local/config/'

## Cd ##
# Converts an arbitrary number of . dots into a command to cd to the proper
# parent dir.
function cd_up
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.{2,}$' --function cd_up

abbr cdp 'cd (projects | fzf)'

## Eza ##
alias l='eza --group-directories-first --icons=auto'
alias ll='eza --group-directories-first --icons=auto --long'
alias lll='eza --group-directories-first --icons=auto --long --almost-all --group --links --header'
alias lt='eza --group-directories-first --icons=auto --tree --git-ignore'

## Docker ##
abbr d docker
abbr dc docker container
abbr di docker image
abbr dn docker network
abbr dps docker ps
abbr dv docker volume

# Run a container
abbr drun 'docker run --rm'

# Run an interactive container
abbr druni 'docker run --rm -it'

# Run an interactive container with the current working directory mounted to
# /mnt/local.
abbr druniv 'docker run --rm -it -v $(pwd):/mnt/local'

# Run an interactive container with the current working directory mounted to
# /mnt/local and set the container working dir to that directory.
abbr drunip 'docker run --rm -it -v $(pwd):/mnt/local -w /mnt/local'

## Jujitsu ##
abbr jb jj bookmark
abbr jbm -- jj bookmark move -t @-
abbr jc jj commit
abbr jk jj status
abbr jl jj log

abbr jjgf jj git fetch
abbr jjgp jj git push

## Julia ##
abbr j. -- julia --project=.
