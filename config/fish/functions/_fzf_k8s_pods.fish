function _fzf_k8s_pods
  set pods (fzf_k8s_pods)
  if test $status -eq 0
    fish_commandline_append (string join ' ' $pods)
  end

  commandline --function repaint
end
