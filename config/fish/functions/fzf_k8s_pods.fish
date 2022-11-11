function fzf_k8s_pods
  k8s_is_valid
  or return

  argparse 'k/kubeconfig=?' -- $argv
  or return

  if set -q _flag_kubeconfig
    set -x kubeconfig $_flag_kubeconfig
  else
    set -x kubeconfig ~/.kube/config
  end

  set selected_pods (
    kubectl --kubeconfig $kubeconfig get pods -o wide |
    _fzf_wrapper --multi --header-lines=1
  )
  if test $status -eq 0
    set cleaned_pods
    for pod in $selected_pods
      set --append cleaned_pods (string split --no-empty --fields 1 ' ' $pod)
    end

    string join \n $cleaned_pods
    return 0
  end
end
