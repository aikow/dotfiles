function k8s_is_valid
    if not command -s -q kubectl &>/dev/null
        # echo 'kubectl not found on PATH or no valid kube config.' >&2
        return 1
    end

    if not test -f ~/.kube/config
        return 1
    end

    return 0
end
