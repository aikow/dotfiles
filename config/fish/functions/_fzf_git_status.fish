function _fzf_git_status --description "Search the output of git status. Replace the current token with the selected file paths."
    set paths (fzf_git_status)
    if test $status -eq 0
        fish_commandline_append (string join ' ' $paths)
    end

    commandline --function repaint
end
