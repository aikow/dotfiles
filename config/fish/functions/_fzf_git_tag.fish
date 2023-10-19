function _fzf_git_tag
    set tags (fzf_git_tag)
    if test $status -eq 0
        fish_commandline_append (string join ' ' $tags)
    end

    commandline --function repaint
end
