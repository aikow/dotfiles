function fzf_git_tag
  git_is_repo
  or return

  set selected_tags (
    git tag --sort -version:refname |
    _fzf_wrapper --multi --preview-window right:70% \
      --preview 'git show --color=always {} ' \
  )
  if test $status -eq 0
    string join \n $selected_tags
    return 0
  end
end
