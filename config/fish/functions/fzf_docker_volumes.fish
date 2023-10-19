function fzf_docker_volumes
    docker_is_valid
    or return

    set selected_volumes (
    docker volume ls |
    _fzf_wrapper \
      --header-lines=1 \
      --multi \
      --preview='docker volume inspect {1}' \
      --preview-window='hidden,nowrap'
  )
    if test $status -eq 0
        set cleaned_volumes
        for volume in volumes
            set --append cleaned_volumes (
        string replace -r '^\w\+\s\+' '' $volume
      )
        end

        string join \n $cleaned_volumes
        return 0
    end
end
