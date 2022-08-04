# Locale
set -gx LC_ALL en_US.UTF-8

# My environment variables
set -gx DOTFILES $HOME/.dotfiles
set -gx MY_SHELL fish

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Man pager
set -gx MANPAGER 'nvim +Man!'

# Neovide
set -gx NEOVIDE_MULTIGRID 1

# Bat
set -gx BAT_THEME gruvbox-dark

# FZF
if command -v fd &>/dev/null
  set -gx FZF_DEFAULT_COMMAND 'fd --type file --follow --hidden --exclude .git --color=always'
  set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
else if command -v rg &>/dev/null
  set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
end
set -gx FZF_DEFAULT_OPTS '--ansi --bind ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-/:toggle-preview,ctrl-t:toggle-preview-wrap --cycle --reverse --border rounded --height 50% --min-height 20 --preview-window right,40%'
