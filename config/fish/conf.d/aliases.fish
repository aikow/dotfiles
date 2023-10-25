# --------------
# |   config   |
# --------------
abbr fishconfig '$EDITOR ~/.config/fish/config.fish'
abbr dotfiles '$EDITOR ~/.dotfiles/'

# ----------
# |   cd   |
# ----------
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ..... 'cd ../../../..'

# ----------
# |   ls   |
# ----------
if command -v exa &>/dev/null
    alias l='exa'
    alias ls='exa --group-directories-first --icons'
    alias lg='exa -l --group-directories-first --icons --git'
    alias lt='exa --group-directories-first --tree --icons'
    alias ll='exa -l --group-directories-first --icons'
    alias lll='exa -la --group-directories-first --icons --group'
else
    alias l='ls'
    alias ll='ls -Al'
end

# --------------
# |   Docker   |
# --------------
# Run a container
abbr drun 'docker run --rm'

# Run an interactive container
abbr druni 'docker run --rm -it'

# Run an interactive container with the current working directory mounted to
# /mnt/local.
abbr druniv 'docker run --rm -it -v $(pwd):/mnt/local'
