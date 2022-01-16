###########################
#  Environment Variables  #
###########################

set -x EDITOR 'nvim'
set -x VISUAL 'nvim'
set -x FZF_DEFAULT_COMMAND 'fd --type file --hidden --no-ignore'
set PATH $HOME/.bin $PATH

if status is-interactive
    # Auto LS command on cd
    function __autols_hook --description "Auto ls" --on-event fish_prompt
        if test "$__autols_last" != "$PWD"
            echo; exa -Fa
        end
        set -g __autols_last "$PWD"
    end

    #################
    #  Keybindings  #
    #################
    #
    # Create custom keybindings
    bind -M insert \ck history-prefix-search-backward
    bind -M insert \cj history-prefix-search-forward

    bind -M default \ck history-search-backward
    bind -M default \cj history-search-forward

    bind -M insert \cn complete
    bind -M insert \cp complete-and-search

    bind -M insert \cf history-token-search-forward
    bind -M insert \cb history-token-search-backward

    bind -M insert \ce edit-command-buffer
    # bind -M insert \co history-prefix-search-backward beginning-of-line forward-bigword
    bind -M insert \co "commandline -i (commandline -f history-prefix-search-backward beginning-of-line forward-bigword)"

    function fish_user_key_bindings
        # Set Vim keybindings
        fish_vi_key_bindings

        # Set FZF keyboard shortcuts
        fzf_key_bindings
    end

    # Start the starship prompt
    starship init fish | source
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval $HOME/.miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

