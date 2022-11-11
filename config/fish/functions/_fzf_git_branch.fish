function _fzf_git_branch --description "Search through all available branches"
  set branches ( fzf_git_branch)
  if test $status -eq 0
    fish_commandline_append (string join ' ' $branches)
  end

  commandline --function repaint
end
