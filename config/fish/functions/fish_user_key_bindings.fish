# ------------------------
# |   Helper functions   |
# ------------------------
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
        set cmd " | less"
    end

    fish_commandline_append cmd
end

function add_fzf
    fish_commandline_append " | fzf"
end

function fish_user_key_bindings
  fish_vi_key_bindings insert
  set fish_cursor_default block
  set fish_cursor_insert line
  set fish_cursor_replace_one underscore
  set fish_cursor_visual block

  bind -M insert \cx\cr reload_config

  bind -M insert \ck history-prefix-search-backward
  bind -M insert \cj history-prefix-search-forward
  bind -M insert \ew history-token-search-forward
  bind -M insert \eb history-token-search-backward
  bind -M insert \cn complete
  bind -M insert \cp complete-and-search

  bind -M insert \cf accept-autosuggestion
  bind -M insert \ef forward-word

  bind -M insert \ce edit_command_buffer

  bind -M insert \cx\cp add_pipe
  bind -M insert \cx\cf add_fzf
  bind -M insert \cx\cl add_less
  bind -M insert \co add_argument
end
