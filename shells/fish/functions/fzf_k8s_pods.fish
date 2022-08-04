function fzf_k8s_pods
  command -v kubectl &>/dev/null && test -f ~/.kube/config \
    || return

  kubectl get pods -o wide \
    | fzf --header-lines=1 \
    | cut -d' ' -f1 \
    | sed -E 's:.*/::g' \
    | fish_commandline_append
end
