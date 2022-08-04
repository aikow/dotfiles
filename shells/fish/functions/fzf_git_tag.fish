function fzf_git_tag
  git_is_repo || return

  git tag --sort -version:refname \
    | fzf --multi --preview-window right:70% \
      --preview 'git show --color=always {} ' \
    | fish_commandline_append
end
