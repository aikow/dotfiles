###########################
#  Environment Variables  #
###########################

function varclear --description 'Remove duplicates from environment variable'
    if test (count $argv) = 1
        set -l newvar
        set -l count 0
        for v in $$argv
            if contains -- $v $newvar
                set count (math $count+1)
            else
                set newvar $newvar $v
            end
        end
        set $argv $newvar
        test $count -gt 0
    else
        for a in $argv
            varclear $a
        end
    end
end

set -x DOTFILES $HOME/.dotfiles
set -x PATH $HOME/.cargo/bin $HOME/.bin $DOTFILES/shells/bin $HOME/.local/bin /usr/local/bin /opt/vc/bin $PATH
# set -x XDG_DATA_DIRS /var/lib/snapd/desktop $XDG_DATA_DIRS
varclear PATH

set -x EDITOR 'nvim'
set -x VISUAL 'nvim'

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
set -x FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS' --bind ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up'

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

    # bind -M insert \cn complete
    # bind -M insert \cp complete-and-search

    bind -M insert \cf history-token-search-forward
    bind -M insert \cb history-token-search-backward
    bind -M insert \ce edit-command-buffer

    function add_pipe
        fish_commandline_append " | "
        commandline -f end-of-buffer
    end
    bind -M insert \cp add_pipe

    function add_argument
        set cmd $history[1]
        set cursor (string length (string split " " $cmd | head -1))
        
        commandline -r $history[1]
        commandline -C $cursor
        commandline -i " -"
    end
    bind -M insert \co add_argument

    function add_less
        if command -v bat &>/dev/null
            set cmd " | bat"
        else
            set cm " | less"
        end

        fish_commandline_append cmd
    end
    bind -M insert \cx\cl add_less

    function add_fzf
        fish_commandline_append " | fzf"
    end
    bind -M insert \cx\cf add_fzf
    
    function reload_config
        commandline -r "source $HOME/.config/fish/config.fish"
        commandline -f execute
    end
    bind -M insert \cx\cr reload_config

    function cdg
        commandline -r "cd (git rev-parse --show-toplevel)"
        commandline -f execute
    end
    bind -M insert \cg cdg


    function fish_user_key_bindings
        # Set Vim keybindings
        fish_vi_key_bindings

        # Set FZF keyboard shortcuts
        fzf_key_bindings
    end

    # Start the starship prompt
    starship init fish | source
end

if test -f ~/.fish.local
  source ~/.fish.local
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval $HOME/.miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

