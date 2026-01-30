# --------------
# |   config   |
# --------------
alias fishconfig '$EDITOR ~/.config/fish/config.fish'
alias lfishconfig '$EDITOR ~/.local/config/fish/config.fish'
alias fishreload 'source ~/.config/fish/conf.d/*.fish; source ~/.config/fish/config.fish'

alias dotfiles '$EDITOR ~/.dotfiles/'
alias ldotfiles '$EDITOR ~/.local/config/'

# ----------
# |   cd   |
# ----------
#
# Converts an arbitrary number of . dots into a command to cd to the proper
# parent dir.
function cd_up
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.{2,}$' --function cd_up

abbr cdp 'cd (projects | fzf)'

# ----------
# |   ls   |
# ----------
if command -q eza
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
end

# --------------
# |   Docker   |
# --------------
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

# ------------------------------------------------------------------------
# | JJ
# ------------------------------------------------------------------------
abbr jb jj bookmark
abbr jc jj commit
abbr jk jj status
abbr jl jj log
