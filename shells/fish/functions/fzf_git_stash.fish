function fzf_git_stash
  git_is_repo || return

  git stash list \
    | fzf --reverse -d: --preview 'git show --color=always {1}' \
    | cut -d: -f1 \
    | fish_commandline_append
end
