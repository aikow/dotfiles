function _fzf_git_stash
  set paths (fzf_git_stash)
  if test $status -eq 0
    fish_commandline_append (string join ' ' $paths)
  end

  commandline --function repaint
end
