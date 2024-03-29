# source /usr/lib/git-core/git-sh-prompt;
source "${DOTFILES_BASH}/prompt/git.bash"
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="verbose"

bg_red=$(tput setab 1)
bg_gray=$(tput setab 240)

bg_c1=""

fg_red=$(tput setaf 1)
fg_white=$(tput setaf 15)
fg_cyan=$(tput setaf 45)
fg_green=$(tput setaf 34)
fg_orange=$(tput setaf 35)
fg_yellow=$(tput setaf 20)
fg_magenta=$(tput setaf 213)

fg_c1=$(tput setaf 127)
fg_c2=$(tput setaf 133)
fg_c3=$(tput setaf 67)
fg_c4=$(tput setaf 73)
fg_c5=$(tput setaf 79)

st_bold=$(tput bold)
st_underlined=$(tput smul)
st_blink=$(tput blink)
st_invert=$(tput rev)

st_reset=$(tput sgr0)

__mkps1_separator() {
  echo "\[${bg_c1}${st_bold}${fg_c1}\] ❯ \[${st_reset}\]"
}

__mkps1_debian_chroot() {
  # This string is intentionally single-quoted:
  # It will be evaluated when $PS1 is evaluated to generate the prompt each time.
  echo '${debian_chroot:+($debian_chroot)}'
}

__mkps1_inject_exitcode() {
  local code=$1
  local separator=$2

  if [[ $code -ne "0" ]]; then
    echo " ${code} ${separator}"
  fi
}

__mkps1_exitcode() {
  # We need to run a function at runtime to evaluate the exitcode.
  echo "\[${bg_red}${fg_white}\]\$(__mkps1_inject_exitcode \$? '\[${bg_gray}${st_bold}${fg_c1}\] ❯\[${st_reset}\]')\[${st_reset}\]"
}

__mkps1_time() {
  echo "\[${bg_gray}${fg_white}\] \t \[${st_reset}\]$(__mkps1_separator)"
}

__mkps1_host() {
  echo "\[${bg_c1}${fg_c1}\]\h\[${st_reset}\]$(__mkps1_separator)"
}

__mkps1_username() {
  echo "\[${bg_c1}${fg_c2}\]\u\[${st_reset}\]$(__mkps1_separator)"
}

__mkps1_workdir() {
  echo "\[${bg_c1}${st_bold}${fg_c3}\]\w\[${st_reset}\]$(__mkps1_separator)"
}

__mkps1_venv() {
  # Check if virtual env exists
  if [[ -n ${CONDA_DEFAULT_ENV} ]]; then
    echo '\[${bg_c1}${fg_c4}\] $(basename ${CONDA_DEFAULT_ENV:="None"})\[${st_reset}\]'"$(__mkps1_separator)"
  elif [[ -n ${VRITUAL_ENV} ]]; then
    echo '\[${bg_c1}${fg_c4}\] $(basename ${VIRTUAL_ENV:="None"})\[${st_reset}\]'"$(__mkps1_separator)"
  else
    echo ""
  fi
}

__mkps1_git() {
  # Escaping the $ is intentional:
  # This is evaluated when the prompt is generated.
  echo "\$(__git_ps1 '\[${bg_c1}${fg_c5}\]%s\[${st_reset}\]$(__mkps1_separator)')"
}

__mkps1_box_top() {
  echo "\[${fg_c3}\]╭\[${st_reset}\]"
}

__mkps1_box_bottom() {
  echo "\[${fg_c3}\]╰\[${st_reset}\]"
}

__mkps1_user_prompt() {
  echo "\[${st_bold}\]\$\[${st_reset}\] "
}

__mkps1() {
  local ps1="\n"
  ps1+="$(__mkps1_box_top)"
  ps1+="$(__mkps1_exitcode)$(__mkps1_time)"
  ps1+="$(__mkps1_host)"
  ps1+="$(__mkps1_username)"
  ps1+="$(__mkps1_venv)"
  ps1+="$(__mkps1_git)"
  ps1+="$(__mkps1_workdir)"
  ps1+="\n$(__mkps1_box_bottom)"
  ps1+="$(__mkps1_user_prompt)"

  echo "$ps1"
}
