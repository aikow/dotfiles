function docker_is_valid
    if not command -s -q docker
        return 1
    end

    return 0
end
