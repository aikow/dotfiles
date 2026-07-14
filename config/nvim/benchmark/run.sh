#!/bin/sh
# Capture a portable Hyperfine snapshot of Neovim startup or buffer opening.
set -eu

usage() {
  echo "usage: $0 [--file FILE] [--runs N] [--warmup N] [--configured-only] NAME" >&2
  exit 64
}

file=-
runs=15
warmup=3
configured_only=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --file)
      [[ "$#" -ge 2 ]] || usage
      file=$2
      shift 2
      ;;
    --runs)
      [[ "$#" -ge 2 ]] || usage
      runs=$2
      shift 2
      ;;
    --warmup)
      [[ "$#" -ge 2 ]] || usage
      warmup=$2
      shift 2
      ;;
    --configured-only)
      configured_only=true
      shift
      ;;
    --help | -h) usage ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ "$#" -eq 1 ]] || usage
name=$1

case "$name" in *[!A-Za-z0-9._-]* | '')
  echo "NAME may contain only letters, numbers, ., _, and -" >&2
  exit 64
  ;;
esac
[[ "$file" = - ]] || [[ -f "$file" ]] || {
  echo "not a regular file: $file" >&2
  exit 66
}

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
state_root=${XDG_STATE_HOME:-"$HOME/.local/state"}/nvim/benchmarks
mkdir -p "$state_root"
json="$state_root/$name.json"
markdown="$state_root/$name.md"

quote() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"
}

runner=$(quote "$script_dir/run-nvim.sh")
target=$(quote "$file")
set -- hyperfine --warmup "$warmup" --runs "$runs" --export-json "$json" --export-markdown "$markdown" \
  --command-name configured "$runner configured $target"
if [[ "$configured_only" = false ]]; then
  set -- "$@" --command-name minimal "$runner minimal $target"
fi

"$@"
printf '\nSaved JSON: %s\nSaved Markdown: %s\n' "$json" "$markdown"
