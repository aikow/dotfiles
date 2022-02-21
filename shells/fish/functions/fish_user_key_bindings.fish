#################
#  Keybindings  #
#################
function add_pipe
    fish_commandline_append " | "
    commandline -f end-of-buffer
end

function add_argument
    set cmd $history[1]
    set cursor (string length (string split " " $cmd | head -1))
    
    commandline -r $history[1]
    commandline -C $cursor
    commandline -i " "
end

function add_less
    if command -v bat &>/dev/null
        set cmd " | bat"
    else
        set cm " | less"
    end

    fish_commandline_append cmd
end

function add_fzf
    fish_commandline_append " | fzf"
end

function reload_config
    commandline -r "source $HOME/.config/fish/config.fish"
    commandline -f execute
end

function fish_user_key_bindings
  bind -M insert \cx\cr reload_config

  bind -M insert \ck history-prefix-search-backward
  bind -M insert \cj history-prefix-search-forward
  bind -M default \ck history-search-backward
  bind -M default \cj history-search-forward
  bind -M insert \cn history-token-search-forward
  bind -M insert \cp history-token-search-backward

  bind -M insert \cf accept-autosuggestion
  bind -M insert \ef forward-single-char

  bind -M insert \ce edit-command-buffer

  bind -M insert \cx\cp add_pipe
  bind -M insert \cx\cf add_fzf
  bind -M insert \cx\cl add_less
  bind -M insert \co add_argument

  fzf_git_key_bindings
  fzf_k8s_key_bindings

  fzf_key_bindings
end
