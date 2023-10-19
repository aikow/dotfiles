function fzf_k8s_jobs
    k8s_is_valid
    or return

    argparse 'k/kubeconfig=?' -- $argv
    or return

    if set -q _flag_kubeconfig
        set -x kubeconfig $_flag_kubeconfig
    else
        set -x kubeconfig ~/.kube/config
    end

    set selected_jobs (
    kubectl --kubeconfig $kubeconfig get jobs,pytorchjobs -o wide |
    _fzf_wrapper --multi --header-lines=1
  )
    if test $status -eq 0
        set cleaned_jobs
        for job in $selected_jobs
            set --append cleaned_jobs (
        string split --no-empty --fields 1 ' ' $job |
        string replace -r '^.*/' ''
      )
        end

        string join \n $cleaned_jobs
        return 0
    end
end
