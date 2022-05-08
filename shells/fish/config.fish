###########################
#  Environment Variables  #
###########################

set -x DOTFILES $HOME/.dotfiles
set -x PATH $HOME/.cargo/bin $HOME/.bin $DOTFILES/shells/bin $HOME/.local/bin /usr/local/bin /opt/vc/bin $PATH
# set -x XDG_DATA_DIRS /var/lib/snapd/desktop $XDG_DATA_DIRS
varclear PATH

set -x LC_ALL C

set -x EDITOR 'nvim'
set -x VISUAL 'nvim'
set -x MY_SHELL 'fish'

if command -v bat &>/dev/null
  set -x BAT_THEME "gruvbox-dark"
end

if command -v fd &>/dev/null
  set -x FZF_DEFAULT_COMMAND 'fd --type file --follow --hidden --exclude .git --color=always'
  set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
  set -x FZF_DEFAULT_OPTS '--ansi'
else if command -v rg &>/dev/null
  set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
end
set -x FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS' --bind ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up --bind ctrl-/:toggle-preview --border --height 50% --min-height 20'

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
