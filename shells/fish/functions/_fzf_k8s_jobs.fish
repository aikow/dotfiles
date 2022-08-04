function _fzf_k8s_jobs
  k8s_is_valid || return

  set selected_jobs (
    kubectl get jobs,pytorchjobs -o wide |
    _fzf_wrapper --multi --header-lines=1
  )
  if test $status -eq 0
    set cleaned_jobs
    for pod in $selected_jobs
      set --append cleaned_jobs (
        string split --no-empty --fields 1 ' ' $pod |
        string replace -r '^.*/' ''
      )
    end

    fish_commandline_append (string join ' ' $cleaned_jobs)
  end

  commandline --function repaint
end
