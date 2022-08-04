function fzf_docker_container
  docker_is_valid || return

  set selected_containers (
    docker container ls --all |
    fzf \
      --header-lines=1 \
      --multi \
      --height 80% --min-height 30 \
      --preview 'docker container inspect {1}' \
      --preview-window 'up,50%,hidden,follow,nowrap' \
      --bind 'ctrl-l:preview(docker logs -f {1})' \
      --bind 'ctrl-o:preview(docker container inspect {1})' \
      --bind 'ctrl-p:preview(docker port {1})'
  )
  if test $status -eq 0
    set cleaned_containe
    for container in containers
      set --append cleaned_containers (
        string split --no-empty --fields 1 $container
      )
    end
    fish_commandline_append (string join ' ' $cleaned_containers)
  end

  commandline --function repaint
end
