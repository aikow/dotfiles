function git_is_repo
    if not command -s -q git
        # echo 'git not found on PATH' >&2
        # commandline --function repaint
        return 1
    end

    if not git rev-parse HEAD >/dev/null 2>&1
        # echo 'not in a git repository' >&2
        # commandline --function repaint
        return 1
    end

    return 0
end
