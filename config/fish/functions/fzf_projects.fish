function fzf_projects
    set projects (
        projects |
            _fzf_wrapper \
            --multi \
            --preview='eza {}' \
            --preview-window='nowrap'
    )

    if test $status -eq 0
        string join \n $projects
    end
end
