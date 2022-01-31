# vim: ft=fish
#
#################
#  Git Aliases  #
#################
#
# These aliases are ported over from Oh-My-ZSH's git aliases.
# See:
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
# - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh

set -l git_version (string split ' ' (git version))[3]

# The name of the current branch
# Usage example: git pull origin (current_branch)
function current_branch  
    set ref (git symbolic-ref HEAD 2> /dev/null); or \
    set ref (git rev-parse --short HEAD 2> /dev/null); or return
    echo $ref | sed -e 's|^refs/heads/||'
end

# Pretty log messages
function _git_log_prettily
  if ! [ -z $1 ]; then
    git log --pretty=$1
  end
end
#
# Work In Progress (wip)
# These features allow to pause a branch development and switch to another one (wip)
# When you want to go back to work, just unwip it
#
# This function return a warning if the current branch is a wip
function work_in_progress
  if git log -n 1 | grep -q -c wip; then
    echo "WIP!!"
  end
end

function current_repository
  set ref (git symbolic-ref HEAD 2> /dev/null); or \
  set ref (git rev-parse --short HEAD 2> /dev/null); or return
  echo (git remote -v | cut -d':' -f 2)
end

# Check if main exists and use instead of master
function git_main_branch 
  command git rev-parse --git-dir &>/dev/null || return
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}
    if command git show-ref -q --verify $ref
      # TODO: echo ${ref:t}
      echo $ref
      return
    end
  end
  echo master
end

# Check for develop and similarly named branches.
function git_develop_branch
  command git rev-parse --git-dir &>/dev/null || return
  for branch in dev devel development
    if command git show-ref -q --verify refs/heads/$branch
      echo $branch
      return
    end
  end
  echo develop
end


###########
# Aliases #
###########
#
# Sorted alphabetically
abbr g 'git'

# git add
abbr ga 'git add'
abbr gaa 'git add --all'
abbr gapa 'git add --patch'
abbr gau 'git add --update'
abbr gav 'git add --verbose'

abbr gap 'git apply'
abbr gapt 'git apply --3way'

# git branch
abbr gb 'git branch'
abbr gba 'git branch -a'
abbr gbd 'git branch -d'
function gbda
  git branch --no-color --merged \
    | command grep -vE "^([+*]|\s*("(git_main_branch)"|"(git_develop_branch)")\s*\$)" \
    | command xargs git branch -d 2>/dev/null
end
abbr gbD 'git branch -D'
abbr gbl 'git blame -b -w'
abbr gbnm 'git branch --no-merged'
abbr gbr 'git branch --remote'

# git bisect
abbr gbs 'git bisect'
abbr gbsb 'git bisect bad'
abbr gbsg 'git bisect good'
abbr gbsr 'git bisect reset'
abbr gbss 'git bisect start'

# git commit
abbr gc 'git commit -v'
abbr gc! 'git commit -v --amend'
abbr gcn! 'git commit -v --no-edit --amend'
abbr gca 'git commit -v -a'
abbr gca! 'git commit -v -a --amend'
abbr gcan! 'git commit -v -a --no-edit --amend'
abbr gcans! 'git commit -v -a -s --no-edit --amend'
abbr gcam 'git commit -a -m'
abbr gcsm 'git commit -s -m'
abbr gcas 'git commit -a -s'
abbr gcasm 'git commit -a -s -m'
abbr gcb 'git checkout -b'
abbr gcf 'git config --list'

function gccd
  command git clone --recurse-submodules $argv
  test -d $argv[-1] && cd $argv[-1] || cd (string split -r -m1 '.git' $argv[1])[1]
end

abbr gcl 'git clone --recurse-submodules'
abbr gclean 'git clean -id'
abbr gpristine 'git reset --hard && git clean -dffx'
abbr gcm 'git checkout (git_main_branch)'
abbr gcd 'git checkout (git_develop_branch)'
abbr gcmsg 'git commit -m'
abbr gco 'git checkout'
abbr gcor 'git checkout --recurse-submodules'
abbr gcount 'git shortlog -sn'
abbr gcp 'git cherry-pick'
abbr gcpa 'git cherry-pick --abort'
abbr gcpc 'git cherry-pick --continue'
abbr gcs 'git commit -S'
abbr gcss 'git commit -S -s'
abbr gcssm 'git commit -S -s -m'

abbr gd 'git diff'
abbr gdca 'git diff --cached'
abbr gdcw 'git diff --cached --word-diff'
abbr gdct 'git describe --tags (git rev-list --tags --max-count=1)'
abbr gds 'git diff --staged'
abbr gdt 'git diff-tree --no-commit-id --name-only -r'
abbr gdup 'git diff @{upstream}'
abbr gdw 'git diff --word-diff'

function gdnolock
  git diff $argv ":(exclude)package-lock.json" ":(exclude)*.lock"
end

function gdv
  git diff -w $argv | view -
end

abbr gf 'git fetch'
# --jobs=<n> was added in git 2.8
vercomp 2.8 -lt $git_version \
  && abbr gfa 'git fetch --all --prune --jobs=10' \
  || abbr gfa 'git fetch --all --prune'
abbr gfo 'git fetch origin'

abbr gfg 'git ls-files | grep'

abbr gg 'git gui citool'
abbr gga 'git gui citool --amend'

function ggf
  if test (count $argv) -ne 1 
    git push --force origin (git_current_branch)
  else
    git push --force origin $argv[1]
  end
end

function ggfl
  if test (count $argv) -ne 1 
    git push --force-with-lease origin (git_current_branch)
  else
    git push --force-with-lease origin $argv[1]
  end
end


function ggl
  if test (count $argv) -ge 2
    git pull origin $argv
  else if test (count $argv) -eq 1
    git pull origin $argv[1]
  else
    git pull origin (git_current_branch)
  end
end

function ggp
  if test (count $argv) -ge 2
    git push origin $argv
  else if test (count $argv) -eq 1
    git push origin $argv[1]
  else
    git push origin (git_current_branch)
  end
end

function ggpnp
  if test (count $argv) -eq 0
    ggl && ggp
  else
    ggl $argv && ggp $argv
  end
end

function ggu
  if test (count $argv) -ne 1
    git pull --rebase origin (git_current_branch)
  else
    git pull --rebase origin $argv[1]
  end
end

abbr ggpur 'ggu'
abbr ggpull 'git pull origin (git_current_branch)'
abbr ggpush 'git push origin (git_current_branch)'

abbr ggsup 'git branch --set-upstream-to=origin/(git_current_branch)'
abbr gpsup 'git push --set-upstream origin (git_current_branch)'

abbr ghh 'git help'

abbr gignore 'git update-index --assume-unchanged'
abbr gignored 'git ls-files -v | grep "^[[:lower:]]"'
abbr git-svn-dcommit-push 'git svn dcommit && git push github (git_main_branch):svntrunk'

abbr gk '\gitk --all --branches &!'
abbr gke '\gitk --all (git log -g --pretty=%h) &!'

abbr gl 'git pull'
abbr glg 'git log --stat'
abbr glgp 'git log --stat -p'
abbr glgg 'git log --graph'
abbr glgga 'git log --graph --decorate --all'
abbr glgm 'git log --graph --max-count=10'
abbr glo 'git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
abbr glog 'git log --oneline --decorate --graph'
abbr gloga 'git log --oneline --decorate --graph --all'
abbr glp "_git_log_prettily"

abbr gm 'git merge'
abbr gmom 'git merge origin/(git_main_branch)'
abbr gmtl 'git mergetool --no-prompt'
abbr gmtlvim 'git mergetool --no-prompt --tool=vimdiff'
abbr gmum 'git merge upstream/(git_main_branch)'
abbr gma 'git merge --abort'

abbr gp 'git push'
abbr gpd 'git push --dry-run'
abbr gpf 'git push --force-with-lease'
abbr gpf! 'git push --force'
abbr gpoat 'git push origin --all && git push origin --tags'
abbr gpr 'git pull --rebase'
abbr gpu 'git push upstream'
abbr gpv 'git push -v'

abbr gr 'git remote'
abbr gra 'git remote add'
abbr grb 'git rebase'
abbr grba 'git rebase --abort'
abbr grbc 'git rebase --continue'
abbr grbd 'git rebase (git_develop_branch)'
abbr grbi 'git rebase -i'
abbr grbm 'git rebase (git_main_branch)'
abbr grbom 'git rebase origin/(git_main_branch)'
abbr grbo 'git rebase --onto'
abbr grbs 'git rebase --skip'
abbr grev 'git revert'
abbr grh 'git reset'
abbr grhh 'git reset --hard'
abbr groh 'git reset origin/(git_current_branch) --hard'
abbr grm 'git rm'
abbr grmc 'git rm --cached'
abbr grmv 'git remote rename'
abbr grrm 'git remote remove'
abbr grs 'git restore'
abbr grset 'git remote set-url'
abbr grss 'git restore --source'
abbr grst 'git restore --staged'
abbr grt 'cd (git rev-parse --show-toplevel || echo .)'
abbr gru 'git reset --'
abbr grup 'git remote update'
abbr grv 'git remote -v'

abbr gsb 'git status -sb'
abbr gsd 'git svn dcommit'
abbr gsh 'git show'
abbr gsi 'git submodule init'
abbr gsps 'git show --pretty=short --show-signature'
abbr gsr 'git svn rebase'
abbr gss 'git status -s'
abbr gst 'git status'

# use the default stash push on git 2.13 and newer
vercomp 2.13 -lt $git_version \
  && abbr gsta 'git stash push' \
  || abbr gsta 'git stash save'

abbr gstaa 'git stash apply'
abbr gstc 'git stash clear'
abbr gstd 'git stash drop'
abbr gstl 'git stash list'
abbr gstp 'git stash pop'
abbr gsts 'git stash show --text'
abbr gstu 'gsta --include-untracked'
abbr gstall 'git stash --all'
abbr gsu 'git submodule update'
abbr gsw 'git switch'
abbr gswc 'git switch -c'
abbr gswm 'git switch (git_main_branch)'
abbr gswd 'git switch (git_develop_branch)'

abbr gts 'git tag -s'
abbr gtv 'git tag | sort -V'
abbr gtl git tag --sort=-v:refname -n -l $argv

abbr gunignore 'git update-index --no-assume-unchanged'
abbr gunwip 'git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
abbr gup 'git pull --rebase'
abbr gupv 'git pull --rebase -v'
abbr gupa 'git pull --rebase --autostash'
abbr gupav 'git pull --rebase --autostash -v'
abbr glum 'git pull upstream (git_main_branch)'

abbr gwch 'git whatchanged -p --abbrev-commit --pretty=medium'

abbr gam 'git am'
abbr gamc 'git am --continue'
abbr gams 'git am --skip'
abbr gama 'git am --abort'
abbr gamscp 'git am --show-current-patch'

function grename
  if test -z $argv[1] -o -z $argv[2]
    echo "Usage: grename old_branch new_branch"
    return 1
  end

  # Rename branch locally
  git branch -m $argv[1] $argv[2]

  # Rename branch in origin remote
  if git push origin :$argv[1]
    git push --set-upstream origin $argv[2]
  end
end

set -e git_version
