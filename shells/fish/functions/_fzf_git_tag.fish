function _fzf_git_tag
  git_is_repo || return

  set selected_tags (
    git tag --sort -version:refname |
    _fzf_wrapper --multi --preview-window right:70% \
      --preview 'git show --color=always {} ' \
  )
  if test $status -eq 0
    fish_commandline_append (string join ' ' $selected_tags)
  end

  commandline --function repaint
end
