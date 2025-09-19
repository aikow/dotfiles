function _fzf_k8s_jobs
    set jobs (fzf-k8s-jobs)
    if test $status -eq 0
        fish_commandline_append (string join ' ' $jobs)
    end

    commandline --function repaint
end
