function _fzf_docker_images
  set images (fzf_docker_images)
  if test $status -eq 0
    fish_commandline_append (string join ' ' $images)
  end

  commandline --function repaint
end
