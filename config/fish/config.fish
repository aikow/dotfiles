# ----------------------
# |   Configure PATH   |
# ----------------------
fish_add_path --path --move $HOME/go/bin
fish_add_path --path --move $HOME/.cargo/bin
fish_add_path --path --move $DOTFILES/bin/all
fish_add_path --path --move $DOTFILES/bin/os/bin
fish_add_path --path --move $HOME/.local/bin

# ----------------------------
# |   Interactive settings   |
# ----------------------------
if status is-interactive
    # Auto-ls command on directory change
    function _autols_hook --description "Auto ls" --on-event fish_prompt
        if test "$_autols_last" != "$PWD"
            echo
            exa --classify --grid --all --icons --group-directories-first
        end
        set -g _autols_last "$PWD"
    end

    fish_user_key_bindings

    # Start the starship prompt
    starship init fish | source
end

# ----------------------------------
# |   Source local configuration   |
# ----------------------------------
if test -f $LOCAL_CONFIG/config.fish
    source $LOCAL_CONFIG/config.fish
end
