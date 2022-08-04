function fzf_git_branch
  git_is_repo || return

  git branch -a --color=always \
    | grep -v '/HEAD\s' \
    | fzf --ansi --multi --tac --preview-window right:70% \
      --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s %C(magenta)[%an]%Creset" (echo {} | sed s/^..// | cut -d" " -f1) ' \
    | sed 's/^..//' \
    | cut -d' ' -f1 \
    | sed 's#^remotes/##' \
    | fish_commandline_append
end
