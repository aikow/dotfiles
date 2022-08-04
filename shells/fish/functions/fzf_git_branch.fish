function fzf_git_branch --description "Search through all available branches"
  git_is_repo || return

  set selected_branches (
    git branch -avv --color=always |
    fzf --ansi --multi --tac --preview-window right:70% \
      --query=(commandline --current-token) \
      --preview 'fzf_preview_branch {}' 
  )
  if test $status -eq 0
    set cleaned_branches

    for branch in $selected_branches
      set --append cleaned_branches (
        clean_string $branch |
        string sub --start 3 |
        string split --no-empty --fields 1 ' ' |
        string replace -r '^remotes/' ''
      )
    end

    fish_commandline_append (string join ' ' $cleaned_branches)
  end

  commandline --function repaint
end
