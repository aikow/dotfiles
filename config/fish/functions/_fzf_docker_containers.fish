function _fzf_docker_containers
    set containers (fzf_docker_containers)
    if test $status -eq 0
        fish_commandline_append (string join ' ' $containers)
    end

    commandline --function repaint
end
