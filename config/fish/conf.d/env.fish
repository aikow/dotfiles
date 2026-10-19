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
# Keep the current row on the terminal background so ANSI filename colors stay readable.
set -gx FZF_DEFAULT_OPTS '
    --ansi
    --color=base16,fg:-1,bg:-1,fg+:-1:bold,bg+:-1,hl:blue,hl+:blue:bold:underline
    --pointer=">"
    --bind ctrl-f:preview-half-page-down
    --bind ctrl-b:preview-half-page-up
    --bind ctrl-d:half-page-down
    --bind ctrl-u:half-page-up
    --bind ctrl-/:toggle-preview
    --bind ctrl-t:toggle-preview-wrap
    --cycle
    --reverse
    --border rounded
    --height 50%
    --min-height 20
    --preview-window right,40%,follow'

# Homebrew
set -gx HOMEBREW_NO_ENV_HINTS 1
