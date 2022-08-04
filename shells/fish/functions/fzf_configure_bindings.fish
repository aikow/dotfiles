function fzf_configure_bindings --description "Configure keybindings for fzf"
  # ---------------
  # |   General   |
  # ---------------
  bind -M insert \cr fzf_fish_history
  bind -M insert \cv fzf_fish_variables
  bind -M insert \ct fzf_files

  # -----------
  # |   Git   |
  # -----------
  bind -M insert \cg\cg git_toplevel
  bind -M insert \cg\cf fzf_git_status
  bind -M insert \cg\cb fzf_git_branch
  bind -M insert \cg\ct fzf_git_tag
  bind -M insert \cg\cl fzf_git_log
  bind -M insert \cg\ch fzf_git_history
  bind -M insert \cg\cr fzf_git_remote
  bind -M insert \cg\cs fzf_git_stash

  # --------------
  # |   Docker   |
  # --------------
  bind -M default \ dc fzf_docker_containers
  bind -M default \ di fzf_docker_images
  bind -M default \ dv fzf_docker_volumes

  # ------------------
  # |   Kubernetes   |
  # ------------------
  bind -M default \ kp fzf_k8s_get_pods
  bind -M default \ kj fzf_k8s_get_jobs
end
