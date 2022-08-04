function k8s_is_valid
  if not command -v kubectl &>/dev/null && test -f ~/.kube/config
    echo 'kubectl not found on PATH or no valid kube config.' >&2
    return 1
  else
    return 0
  end
end
