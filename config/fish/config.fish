# ----------------------
# |   Configure PATH   |
# ----------------------
fish_add_path --path --move $DOTFILES/bin
fish_add_path --path --move $HOME/.local/bin

# ----------------------------
# |   Interactive settings   |
# ----------------------------
if status is-interactive
    # Auto-ls command on directory change
    function autols_hook --description "Auto ls" --on-event fish_prompt
        if test "$_autols_last" != "$PWD"
            eza --classify --grid --all --icons --group-directories-first
            echo
        end
        set -g _autols_last "$PWD"
    end

    function newline_before_prompt --description "Print a newline before displaying the prompt" --on-event fish_postexec
        echo
    end

    fish_user_key_bindings

    fish_config theme choose base16-default
    fish_config prompt choose astronaut
end

# ----------------------------------
# |   Source local configuration   |
# ----------------------------------
if test -f $LOCAL_CONFIG/config.fish
    source $LOCAL_CONFIG/config.fish
end
