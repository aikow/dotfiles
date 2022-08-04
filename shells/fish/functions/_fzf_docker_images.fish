function _fzf_docker_images
  docker_is_valid || return

  set selected_images (
    docker image ls |
    _fzf_wrapper \
      --header-lines=1 \
      --multi \
      --preview='docker image inspect {3}' \
      --preview-window='hidden,nowrap'
  )
  if test $status -eq 0
    set cleaned_images
    for image in images
      set --append cleaned_images (
        string split -r '^(\S+)\s+(\S+)\s+.*$' '\1:\2' $image
      )
    end

    fish_commandline_append (string join ' ' $cleaned_images)
  end

  commandline --function repaint
end
