function fzf_configure_bindings --description "Configure keybindings for fzf"
    # ---------------
    # |   General   |
    # ---------------
    bind -M insert \cr _fzf_fish_history
    bind -M insert \cv _fzf_fish_variables
    bind -M insert \ct _fzf_files

    # -----------
    # |   Git   |
    # -----------
    bind -M insert \cg\cg git_toplevel
    bind -M default \ gg git_toplevel

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

    # --------------
    # |   Docker   |
    # --------------
    bind -M default \ dc _fzf_docker_containers
    bind -M default \ di _fzf_docker_images
    bind -M default \ dv _fzf_docker_volumes

    # ------------------
    # |   Kubernetes   |
    # ------------------
    bind -M default \ kp _fzf_k8s_pods
    bind -M default \ kj _fzf_k8s_jobs
end
