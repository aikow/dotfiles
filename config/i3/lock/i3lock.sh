#!/usr/bin/env bash
set -eu

[[ -z "$(pgrep i3lock)" ]] || exit
i3lock -n -u -t -i "${HOME}/Pictures/Backgrounds/nord_theme_mountain.png"
