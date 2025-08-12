# Bind C-e to edit the command line
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Bind C-o to add an argument to the previous command
bindkey -s '^o' '^[k0Ea '

# Bind C-x C-l to pipe the previous command into less
bindkey -s '^x^l' '^[kA | less'

# Bind C-x C-p to pipe the previous command
bindkey -s '^x^p' '^[kA | '

# History seach
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward

# Clear screen
bindkey "^l" clear-screen

function join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

function bind_function() {
  local func="${1?Missing function to bind}"
  local key="${2?Missing key to bind to}"
  eval "function fzf-${func}-widget() { local result=\"\$(${func} | join-lines)\"; zle reset-prompt; LBUFFER+=\"\$result\" }"
  eval "zle -N fzf-${func}-widget"
  eval "bindkey '${key}' fzf-${func}-widget"
}

bind_function fzf_git_status ^g^f
bind_function fzf_git_branch ^g^b
bind_function fzf_git_tag ^g^t
bind_function fzf_git_remote ^g^r
bind_function fzf_git_log ^g^h
bind_function fzf_git_stash ^g^s
