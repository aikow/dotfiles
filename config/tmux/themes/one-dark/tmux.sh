#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

onedark_black="#282c34"
onedark_blue="#61afef"
onedark_yellow="#e5c07b"
onedark_red="#e06c75"
onedark_white="#aab2bf"
onedark_green="#98c379"
onedark_visual_grey="#3e4452"
onedark_comment_grey="#5c6370"

_t_get() {
  local option=$1
  local default_value=$2
  local option_value
  option_value="$(tmux show-option -gqv "$option")"

  if [[ -z $option_value ]]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

_t_set() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

_t_setw() {
  local option=$1
  local value=$2
  tmux set-window-option -gq "$option" "$value"
}

_t_set "status" "on"
_t_set "status-justify" "left"

_t_set "status-left-length" "100"
_t_set "status-right-length" "100"
_t_set "status-right-attr" "none"

_t_set "message-fg" "$onedark_white"
_t_set "message-bg" "$onedark_black"

_t_set "message-command-fg" "$onedark_white"
_t_set "message-command-bg" "$onedark_black"

_t_set "status-attr" "none"
_t_set "status-left-attr" "none"

_t_setw "window-status-fg" "$onedark_black"
_t_setw "window-status-bg" "$onedark_black"
_t_setw "window-status-attr" "none"

_t_setw "window-status-activity-bg" "$onedark_black"
_t_setw "window-status-activity-fg" "$onedark_black"
_t_setw "window-status-activity-attr" "none"

_t_setw "window-status-separator" ""

_t_set "window-style" "fg=$onedark_white"
_t_set "window-active-style" "fg=$onedark_white"

_t_set "pane-border-fg" "$onedark_white"
_t_set "pane-border-bg" "$onedark_black"
_t_set "pane-active-border-fg" "$onedark_green"
_t_set "pane-active-border-bg" "$onedark_black"

_t_set "display-panes-active-colour" "$onedark_yellow"
_t_set "display-panes-colour" "$onedark_blue"

_t_set "status-bg" "$onedark_black"
_t_set "status-fg" "$onedark_white"

_t_set "@prefix_highlight_fg" "$onedark_black"
_t_set "@prefix_highlight_bg" "$onedark_green"
_t_set "@prefix_highlight_copy_mode_attr" "fg=$onedark_black,bg=$onedark_green"
_t_set "@prefix_highlight_output_prefix" "  "

status_widgets=""
time_format="%R"
date_format="%d/%m/%Y"

_t_set \
  "status-right" \
  "#[fg=$onedark_white,bg=$onedark_black,nounderscore,noitalics]${time_format}  ${date_format} #[fg=$onedark_visual_grey,bg=$onedark_black]#[fg=$onedark_visual_grey,bg=$onedark_visual_grey]#[fg=$onedark_white, bg=$onedark_visual_grey]${status_widgets} #[fg=$onedark_green,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_black,bg=$onedark_green,bold] #h #[fg=$onedark_yellow, bg=$onedark_green]#[fg=$onedark_red,bg=$onedark_yellow]"
_t_set \
  "status-left" \
  "#[fg=$onedark_black,bg=$onedark_green,bold] #S #{prefix_highlight}#[fg=$onedark_green,bg=$onedark_black,nobold,nounderscore,noitalics]"

_t_set \
  "window-status-format" \
  "#[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_black] #I  #W #[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]"
_t_set \
  "window-status-current-format" \
  "#[fg=$onedark_black,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_visual_grey,nobold] #I  #W #[fg=$onedark_visual_grey,bg=$onedark_black,nobold,nounderscore,noitalics]"
