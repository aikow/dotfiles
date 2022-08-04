function fzf_git_remote
  git_is_repo || return

  git remote -v \
    | awk '{print $1 "\t" $2}' \
    | uniq \
    | fzf --tac \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' \
    | cut -d'\t' -f1 \
    | fish_commandline_append
end
