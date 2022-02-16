# Deciphered from fzf-file-widget. Somewhat unclear why it doesn't exist already!
function fzf_add_to_commandline -d 'add stdin to the command line, for fzf functions'
  read -l result
  commandline -t ""
  commandline -it -- (string escape $result)
  commandline -f repaint
end

# https://gist.github.com/aluxian/9c6f97557b7971c32fdff2f2b1da8209
function __fzf_git_is_repo
  command -s -q git
    and git rev-parse HEAD >/dev/null 2>&1
end

function __fzf_down
  fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview $argv
end

function fzf_git_toplevel
  commandline -r "cd (git rev-parse --show-toplevel)"
  commandline -f execute
end

function fzf_git_status
  __fzf_git_is_repo || return
  git -c color.status=always status --short \
    | __fzf_down -m --ansi --nth 2 \
        --preview 'git diff --color=always HEAD -- {-1} | head -500' \
    | cut -c4- \
    | sed 's/.* -> //' \
    | fzf_add_to_commandline

  commandline -f repaint
end

function fzf_git_branch
  __fzf_git_is_repo || return

  git branch -a --color=always \
    | grep -v '/HEAD\s' \
    | __fzf_down --ansi --multi --tac --preview-window right:70% \
      --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s %C(magenta)[%an]%Creset" (echo {} | sed s/^..// | cut -d" " -f1) ' \
    | sed 's/^..//' \
    | cut -d' ' -f1 \
    | sed 's#^remotes/##' \
    | fzf_add_to_commandline
end

function fzf_git_tag
  __fzf_git_is_repo || return

  git tag --sort -version:refname \
    | __fzf_down --multi --preview-window right:70% \
      --preview 'git show --color=always {} ' \
    | fzf_add_to_commandline
end

function fzf_git_log
  __fzf_git_is_repo || return

  git log --color=always --graph --date=short --format="%C(auto)%cd %h%d %s %C(magenta)[%an]%Creset" \
    | __fzf_down --ansi --no-sort --reverse --multi \
      --bind 'ctrl-s:toggle-sort' \
      --header 'Press CTRL-S to toggle sort' \
      --preview 'git show --color=always (echo {} | grep -o "[a-f0-9]\{7,\}") ' \
    | sed -E 's/.*([a-f0-9]{7,}).*/\1/' \
    | fzf_add_to_commandline
end

function fzf_git_remote
  __fzf_git_is_repo || return

  git remote -v \
    | awk '{print $1 "\t" $2}' \
    | uniq \
    | __fzf_down --tac \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' \
    | cut -d'\t' -f1 \
    | fzf_add_to_commandline
end

function fzf_git_stash
  __fzf_git_is_repo || return

  git stash \
    | __fzf_down --reverse -d: --preview 'git show --color=always {1}' \
    | cut -d: -f1 \
    | fzf_add_to_commandline
end


# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
function fzf_git_key_bindings -d "Set custom key bindings for git+fzf"
  bind -M insert \cg\cg fzf_git_toplevel
  bind -M insert \cg\cf fzf_git_status
  bind -M insert \cg\cb fzf_git_branch
  bind -M insert \cg\ct fzf_git_tag
  bind -M insert \cg\ch fzf_git_log
  bind -M insert \cg\cr fzf_git_remote
  bind -M insert \cg\cs fzf_git_stash
end
