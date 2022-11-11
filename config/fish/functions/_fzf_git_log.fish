function _fzf_git_log --description "Search the output of git log and preview commits. Replace the current token with the selected commit hash."
  set commits (fzf_git_log)
  if test $status -eq 0
    fish_commandline_append (string join ' ' $commits)
  end

  commandline --function repaint
end
