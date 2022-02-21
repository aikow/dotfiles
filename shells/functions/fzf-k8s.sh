#!/usr/bin/env sh

function __has_k8s() {
  command -v kubectl &>/dev/null && [[ -f ~/.kube/config ]]
}


function fzf_k8s_pods() {
  __has_k8s || return

  kubectl get pods -o wide \
    | fzf --header-lines=1 \
    | cut -d' ' -f1 \
    | sed -E 's:.*/::g'
}


function fzf_k8s_jobs() {
  __has_k8s || return

  kubectl get jobs,pytorchjobs -o wide \
    | fzf --header-lines=1 \
    | cut -d' ' -f1 \
    | sed -E 's:.*/::g'
}
