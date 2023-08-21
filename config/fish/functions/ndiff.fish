function ndiff
    git_is_repo
    or return

    nvim -c "DiffviewOpen $argv[1]" -c tabonly
end
