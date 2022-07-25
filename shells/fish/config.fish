###########################
#  Environment Variables  #
###########################

set -gx DOTFILES $HOME/.dotfiles
fish_add_path --path --move $HOME/.cargo/bin
fish_add_path --path --move $HOME/.local/bin
fish_add_path --path --move $DOTFILES/shells/bin
fish_add_path --path --move $HOME/.bin

set -gx LC_ALL en_US.UTF-8

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MY_SHELL fish
set -gx MANPAGER 'nvim +Man!'

if command -v bat &>/dev/null
  set -gx BAT_THEME gruvbox-dark
end

if command -v fd &>/dev/null
  set -gx FZF_DEFAULT_COMMAND 'fd --type file --follow --hidden --exclude .git --color=always'
  set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
else if command -v rg &>/dev/null
  set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
end
set -gx FZF_DEFAULT_OPTS "--ansi --bind ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-/:toggle-preview --border --height 50% --min-height 20 --preview-window right,40%,follow"

# ----------------------------
# |   Interactive settings   |
# ----------------------------
if status is-interactive
    # Auto LS command on cd
    function __autols_hook --description "Auto ls" --on-event fish_prompt
        if test "$__autols_last" != "$PWD"
            echo; exa -Fa
        end
        set -g __autols_last "$PWD"
    end

    fish_user_key_bindings

    # Start the starship prompt
    starship init fish | source
end

# ----------------------------------
# |   Source local configuration   |
# ----------------------------------
if test -f ~/.fish.local
  source ~/.fish.local
end
