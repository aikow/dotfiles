function _fzf_docker_volumes
  docker_is_valid || return

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
    fish_commandline_append (string join ' ' $cleaned_volumes)
  end

  commandline --function repaint
end

