function _fzf_docker_volumes
    set volumes (fzf_docker_volumes)
    if test $status -eq 0
        fish_commandline_append (string join ' ' $volumes)
    end

    commandline --function repaint
end
