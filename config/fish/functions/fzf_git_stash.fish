function fzf_git_stash
    git_is_repo
    or return

    set selected_paths (
    git stash list |
    _fzf_wrapper -d: --preview 'git show --color=always {1}'
  )
    if test $status -eq 0
        set cleaned_paths
        for path in $selected_paths
            set --append cleaned_paths (string split --fields 1 ':' $path)
        end

        string join \n $cleaned_paths
        return 0
    end
end
