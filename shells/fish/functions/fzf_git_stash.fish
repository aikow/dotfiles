function fzf_git_stash
  git_is_repo || return

  set selected_paths (
    git stash list |
    fzf -d: --preview 'git show --color=always {1}'
  )
  if test $status -eq 0
    set cleaned_paths
    for path in $selected_paths
      set --append cleaned_paths (string split --fields 1 ':' $path)
    end

    fish_commandline_append (string join ' ' $cleaned_paths)
  end

  commandline --function repaint
end
