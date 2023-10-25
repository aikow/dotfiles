#!/usr/bin/env sh

__git_repo() {
  git rev-parse HEAD >/dev/null 2>&1
}

fzf_git_status() {
  __git_repo || return

  git -c color.status=always status --short \
    | fzf -m --ansi --nth 2..,.. \
      --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' \
    | cut -c4- \
    | sed 's/.* -> //'
}

fzf_git_branches() {
  __git_repo || return

  git branch -a --color=always \
    | grep -v '/HEAD\s' \
    | sort \
    | fzf --ansi --multi --tac --preview-window right:70% \
      --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' \
    | sed 's/^..//' \
    | cut -d' ' -f1 \
    | sed 's#^remtes/##'
}

fzf_git_tags() {
  __git_repo || return

  git tag --sort -version:refname \
    | fzf --multi --preview-window right:70% \
      --preview 'git show --color=always {}'
}

fzf_git_commits() {
  __git_repo || return

  git log --date=short --graph --color=always \
    --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" \
    | fzf --ansi --no-sort --reverse --multi \
      --bind 'ctrl-s:toggle-sort' \
      --header 'Press CTRL-S to toggle sort' \
      --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' \
    | grep -o "[a-f0-9]\{7,\}"
}

fzf_git_remotes() {
  __git_repo || return

  git remote -v \
    | awk '{print $1 "\t" $2}' \
    | uniq \
    | fzf --tac \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' \
    | cut -d"\t" -f1
}

fzf_git_stash() {
  __git_repo || return

  git stash list \
    | fzf --reverse -d: \
      --preview 'git show --color=always {1}' \
    | cut -d: -f1
}
