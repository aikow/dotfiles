#!/usr/bin/env sh

__has_k8s() {
  command -v kubectl 1>/dev/null 2>&1 && [ -f ~/.kube/config ]
}

fzf_k8s_pods() {
  __has_k8s || return

  kubectl get pods -o wide \
    | fzf --header-lines=1 \
      --preview-window='hidden' \
      --preview='kubectl logs "$(cut -d" " -f1 <<<{} | sed -E "s:.*/::g")"' \
    | cut -d' ' -f1 \
    | sed -E 's:.*/::g'
}

fzf_k8s_jobs() {
  __has_k8s || return

  kubectl get jobs,pytorchjobs -o wide \
    | fzf --header-lines=1 \
      --preview-window='hidden' \
      --preview='kubectl logs "$(cut -d" " -f1 <<<{} | sed -E "s:.*/::g")"' \
    | cut -d' ' -f1 \
    | sed -E 's:.*/::g'
}
