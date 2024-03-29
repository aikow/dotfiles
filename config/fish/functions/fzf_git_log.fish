function fzf_git_log --description "Search the output of git log and preview commits. Replace the current token with the selected commit hash."
    git_is_repo
    or return

    # see documentation for git format placeholders at
    # https://git-scm.com/docs/git-log#Documentation/git-log.txt-emnem
    # %h gives you the abbreviated commit hash, which is useful for saving
    # screen space, but we will have to expand it later below.
    set log_fmt_str '%C(bold blue)%h%C(reset) - %C(cyan)%ad%C(reset) %C(yellow)%d%C(reset) %C(normal)%s%C(reset)  %C(dim normal)[%an]%C(reset)'
    set selected_log_lines (
    git log --color=always --format=format:$log_fmt_str --date=short | \
    _fzf_wrapper --ansi \
      --multi \
      --tiebreak=index \
      --preview='git show --color=always --stat --patch {1}' \
      --query=(commandline --current-token)
  )
    if test $status -eq 0
        set commit_hashes
        for line in $selected_log_lines
            set abbreviated_commit_hash (string split --field 1 " " $line)
            set full_commit_hash (git rev-parse $abbreviated_commit_hash)
            set --append commit_hashes $full_commit_hash
        end

        string join \n $commit_hashes
        return 0
    end
end
