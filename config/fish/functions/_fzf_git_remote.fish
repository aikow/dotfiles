function _fzf_git_remote
    set remotes (fzf_git_remote)
    if test $status -eq 0
        fish_commandline_append (string join ' ' $remotes)
    end

    commandline --function repaint
end
