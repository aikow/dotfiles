# Repository and environment names are untrusted display data. Reject controls
# and escape prompt syntax; never evaluate names as shell code.
export VIRTUAL_ENV_DISABLE_PROMPT=1
export CONDA_CHANGEPS1=false
unsetopt prompt_subst prompt_bang
setopt prompt_percent

autoload -Uz add-zsh-hook vcs_info
zstyle ':vcs_info:dotfiles:*' enable git
zstyle ':vcs_info:git:dotfiles:*' check-for-changes true
zstyle ':vcs_info:git:dotfiles:*' formats 'git:[%b%c%u]'
zstyle ':vcs_info:git:dotfiles:*' actionformats 'git:[%b%c%u|%a]'
zstyle ':vcs_info:git:dotfiles:*' stagedstr '+'
zstyle ':vcs_info:git:dotfiles:*' unstagedstr '*'

_dotfiles_prompt_escape() {
  emulate -L zsh
  REPLY=''
  [[ -n $1 && ${#1} -le 4096 && $1 != *[[:cntrl:]]* ]] || return 1
  REPLY=${1//\%/%%}
}

_dotfiles_prompt_vcs() {
  emulate -L zsh
  local directory=$PWD repository
  REPLY=''

  # The nearest repository wins; prefer Jujutsu when .jj and .git coexist.
  while true; do
    if [[ -e $directory/.jj ]]; then
      if (( $+commands[jj] )) && repository=$(
        command jj --ignore-working-copy --no-pager log --no-graph --color=never -r @ -T \
          '"jj:[@ " ++ separate(" ", format_short_change_id_with_change_offset(self), format_short_commit_id(commit_id), bookmarks, if(conflict, "conflict")) ++ "]"' 2>/dev/null
      ); then
        _dotfiles_prompt_escape "$repository"
      fi
      return 0
    elif [[ -e $directory/.git ]]; then
      vcs_info dotfiles 2>/dev/null
      _dotfiles_prompt_escape "$vcs_info_msg_0_"
      return 0
    fi
    [[ $directory == / ]] && return 0
    directory=${directory:h}
  done
}

_dotfiles_prompt_precmd() {
  local -i code=$?
  # Leave these options set for Zsh's later prompt expansion, outside this hook.
  unsetopt prompt_subst prompt_bang
  setopt prompt_percent
  # Separate new prompts from output, without adding space on Ctrl-L redraws.
  print
  _dotfiles_prompt_build "$code"
}

_dotfiles_prompt_build() {
  emulate -L zsh
  local -i code=$1
  local environment='' REPLY='' blue='' yellow='' reset=''

  if [[ -n ${TERM:-} && $TERM != dumb ]] &&
      zmodload zsh/terminfo 2>/dev/null && (( ${terminfo[colors]:-0} >= 8 )); then
    blue='%b%F{blue}'
    yellow='%F{yellow}'
    reset='%f'
  fi

  PROMPT=''
  if [[ -n ${SSH_CONNECTION:-}${SSH_CLIENT:-}${SSH_TTY:-} ]] || (( EUID == 0 )); then
    PROMPT+='%n@%m '
  fi
  PROMPT+="${blue}%~${reset}"
  _dotfiles_prompt_vcs
  [[ -z $REPLY ]] || PROMPT+="  $REPLY"

  if [[ -n ${CONDA_DEFAULT_ENV:-} ]]; then
    environment=${CONDA_DEFAULT_ENV##*/}
  elif [[ -n ${VIRTUAL_ENV:-} ]]; then
    environment=${VIRTUAL_ENV%/}
    environment=${environment##*/}
  fi
  if _dotfiles_prompt_escape "$environment"; then
    PROMPT+="  [$REPLY]"
  fi

  PROMPT+=$'\n'
  (( code == 0 )) || PROMPT+="${yellow}${code}${reset} "
  PROMPT+='%# '
  RPROMPT=''
  RPS2=''
  return 0
}

RPROMPT=''
RPS2=''
add-zsh-hook precmd _dotfiles_prompt_precmd
