function fzf_git_remote
  git_is_repo
  or return

  set log_format (string escape 'format:%C(auto)%cd %h%d %s')
  set selected_remotes (
    git remote -v |
    awk '{print $1 "\t" $2}' |
    uniq |
    _fzf_wrapper --tac \
      --preview 'git log --color=always --oneline --graph --date=short --pretty='$log_format'{1}' \
  )
  if test $status -eq 0
    set cleaned_remotes
    for remote in $selected_remotes
      set --append cleaned_remotes (
        string split --fields 1 '\t'
      )
    end
    string join \n $cleaned_remotes
    return 0
  end
end
