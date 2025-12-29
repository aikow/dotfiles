if not status is-interactive
    exit
end

if not command -q fzf
    exit
end

# Install the default bindings, which are mnemonic and minimally conflict with fish's preset bindings
fzf --fish | source

## Git
bind -M insert \cg\cf _fzf_git_status
bind -M default \ gf _fzf_git_status

bind -M insert \cg\cb _fzf_git_branch
bind -M default \ gb _fzf_git_branch

bind -M insert \cg\ct _fzf_git_tag
bind -M default \ gt _fzf_git_tag

bind -M insert \cg\ch _fzf_git_log
bind -M default \ gh _fzf_git_log

bind -M insert \cg\cr _fzf_git_remote
bind -M default \ gr _fzf_git_remote

bind -M insert \cg\cs _fzf_git_stash
bind -M default \ gs _fzf_git_stash
