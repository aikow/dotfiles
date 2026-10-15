source "${DOTFILES_BASH}/config/git.bash"
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="verbose"

# This prompt renders environments itself, including changes after startup.
export VIRTUAL_ENV_DISABLE_PROMPT=1
export CONDA_CHANGEPS1=false

__mkps1_blue=''
__mkps1_yellow=''
__mkps1_reset=''
if [[ -n ${TERM:-} && ${TERM} != dumb ]] && command -v tput >/dev/null 2>&1; then
  __mkps1_colors=$(tput colors 2>/dev/null) || __mkps1_colors=0
  if [[ $__mkps1_colors =~ ^[0-9]+$ ]] && (( __mkps1_colors >= 8 )); then
    __mkps1_blue="$(tput bold)$(tput setaf 4)"
    __mkps1_yellow=$(tput setaf 3)
    __mkps1_reset=$(tput sgr0)
  fi
  unset __mkps1_colors
fi

__mkps1_vcs() {
  local directory=$PWD
  local status

  # Walk upward like the public-domain example in the Jujutsu wiki:
  # https://github.com/jj-vcs/jj/wiki/Shell-Prompt
  # Check .jj first for colocated repositories, but respect nested Git repos.
  while :; do
    if [[ -e $directory/.jj ]]; then
      # Never snapshot or launch a pager while drawing the prompt. Keep the
      # wiki's fields, using the terminal foreground instead of VCS colors.
      if command -v jj >/dev/null 2>&1 && status=$(
        jj --ignore-working-copy --no-pager log --no-graph --color=never -r @ -T \
          '"jj:[@ " ++ separate(" ", format_short_change_id_with_change_offset(self), format_short_commit_id(commit_id), bookmarks, if(conflict, "conflict")) ++ "]"' 2>/dev/null
      ); then
        # Treat bookmark names as data; reject terminal control characters.
        if [[ -n $status && $status != *[[:cntrl:]]* ]]; then
          printf ' %s' "$status"
        fi
      fi
      return
    elif [[ -e $directory/.git ]]; then
      __git_ps1 ' (%s)'
      return
    fi
    [[ $directory == / ]] && return
    directory=${directory%/*}
    directory=${directory:-/}
  done
}

__mkps1_context() {
  # Capture the previous command's status before Git or environment lookups.
  local code=$1
  local environment=''

  # Names are printed as data after prompt decoding, never inserted into code.
  __mkps1_vcs
  if [[ -n ${CONDA_DEFAULT_ENV:-} ]]; then
    environment=${CONDA_DEFAULT_ENV##*/}
  elif [[ -n ${VIRTUAL_ENV:-} ]]; then
    environment=${VIRTUAL_ENV%/}
    environment=${environment##*/}
  fi
  if [[ -n $environment && $environment != *[[:cntrl:]]* ]]; then
    printf ' [%s]' "$environment"
  fi

  printf '\n'
  if [[ $code -ne 0 ]]; then
    if [[ -n $__mkps1_yellow ]]; then
      # Command-substitution output needs literal Readline markers: Bash has
      # already decoded prompt escapes such as \[ and \].
      printf '\001%s\002%s\001%s\002 ' "$__mkps1_yellow" "$code" "$__mkps1_reset"
    else
      printf '%s ' "$code"
    fi
  fi
  # The trailing space also keeps command substitution from stripping the
  # newline when there is no exit code to display.
  if (( EUID == 0 )); then
    printf '# '
  else
    printf '$ '
  fi
}

__mkps1_precmd() {
  local code=$?
  # Separate new prompts from output, without adding space on Ctrl-L redraws.
  printf '\n'
  return "$code"
}

__mkps1() {
  local ps1=''
  if [[ -n ${SSH_CONNECTION:-}${SSH_CLIENT:-}${SSH_TTY:-} ]]; then
    ps1+='\u@\h '
  fi
  if [[ -n $__mkps1_blue ]]; then
    ps1+="\\[${__mkps1_blue}\\]\\w\\[${__mkps1_reset}\\]"
  else
    ps1+='\w'
  fi
  # One substitution captures $? before any prompt work; its output is not
  # recursively evaluated.
  ps1+='$(__mkps1_context "$?")'
  printf '%s' "$ps1"
}
