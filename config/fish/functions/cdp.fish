function cdp
    set project (projects | _fzf_wrapper --ansi)
    if test $status -eq 0
        cd $project
    end
end
