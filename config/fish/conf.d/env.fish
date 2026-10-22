# Locale
set -gx LC_ALL en_US.UTF-8

# My environment variables
set -gx DOTFILES $HOME/.dotfiles
set -gx DOTFILES_FISH $HOME/.dotfiles/config/fish
set -gx LOCAL_CONFIG $HOME/.local/config/fish

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Man pager
set -gx MANPAGER 'nvim +Man!'

# Bat
set -gx BAT_THEME gruvbox-dark

# File colors: use the terminal's ANSI palette so colors follow its theme.
set -gx LS_COLORS (string collect < "$DOTFILES/config/dircolors/ls_colors")

# FZF
set -gx FZF_DEFAULT_COMMAND 'fd --type file --follow --hidden --exclude .git --color=always'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_DEFAULT_OPTS (string collect < "$DOTFILES/config/fzf/default_opts")

# Skim
set -gx SKIM_DEFAULT_COMMAND $FZF_DEFAULT_COMMAND
set -gx SKIM_CTRL_T_COMMAND $SKIM_DEFAULT_COMMAND
set -gx SKIM_DEFAULT_OPTIONS (string collect < "$DOTFILES/config/skim/default_opts")

# Homebrew
set -gx HOMEBREW_NO_ENV_HINTS 1
