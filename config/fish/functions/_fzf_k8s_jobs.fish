function _fzf_k8s_jobs
    set jobs (fzf_k8s_jobs)
    if test $status -eq 0
        fish_commandline_append (string join ' ' $jobs)
    end

    commandline --function repaint
end
