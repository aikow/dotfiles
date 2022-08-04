function fzf_k8s_pods
  k8s_is_valid || return

  set selected_pods (
    kubectl get pods -o wide |
    fzf --multi --header-lines=1
  )
  if test $status -eq 0
    set cleaned_pods
    for pod in $selected_pods
      set --append cleaned_pods (string split --no-empty --fields 1 ' ' $pod)
    end

    fish_commandline_append (string join ' ' $cleaned_pods)
  end

  commandline --function repaint
end
