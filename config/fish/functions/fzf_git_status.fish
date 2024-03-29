function fzf_git_status --description "Search the output of git status. Replace the current token with the selected file paths."
    git_is_repo
    or return

    set selected_paths (
    # Pass configuration color.status=always to force status to use colors
    # even though output is sent to a pipe
    git -c color.status=always status --short |
    _fzf_wrapper --ansi \
      --multi \
      --query=(commandline --current-token) \
      --preview='_fzf_preview_changed_file {}'
  )
    if test $status -eq 0
        # git status --short automatically escapes the paths of most files for us
        # so not going to bother trying to handle the few edges cases of weird
        # file names that should be extremely rare (e.g. "this;needs;escaping")
        set cleaned_paths
        for path in $selected_paths
            if test (string sub --length 1 $path) = R
                # path has been renamed and looks like "R LICENSE -> LICENSE.md"
                # extract the path to use from after the arrow
                set --append cleaned_paths (string split -- "-> " $path)[-1]
            else
                set --append cleaned_paths (string sub --start=4 $path)
            end
        end

        string join \n $cleaned_paths
        return 0
    end
end
