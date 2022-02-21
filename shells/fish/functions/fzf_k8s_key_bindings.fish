#!/usr/bin/env fish

function fzf_k8s_get_pods
  command -v kubectl &>/dev/null && test -f ~/.kube/config \
    || return

  kubectl get pods -o wide \
    | fzf --header-lines=1 \
    | cut -d' ' -f1 \
    | sed -E 's:.*/::g' \
    | commandline_append
end


function fzf_k8s_get_jobs
  command -v kubectl &>/dev/null && test -f ~/.kube/config \
    || return

  kubectl get jobs,pytorchjobs -o wide \
    | fzf --header-lines=1 \
    | cut -d' ' -f1 \
    | sed -E 's:.*/::g' \
    | commandline_append
end

function fzf_k8s_key_bindings
  bind -M insert \cg\cp fzf_k8s_get_pods
  bind -M insert \cg\cj fzf_k8s_get_jobs
end

