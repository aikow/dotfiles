#!/usr/bin/env bash
# Compare two snapshots produced by run.sh. Requires jq.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 BEFORE.json AFTER.json" >&2
  exit 64
fi

jq -rs '
  def measurements: .results | map({command, mean, stddev});
  def fmt_ms: ((. * 10 | round) / 10 | tostring) + " ms";
  def fmt_delta_ms: . as $value | (if $value >= 0 then "+" else "" end) + ((($value * 10 | round) / 10) | tostring) + " ms";
  def fmt_percent: . as $value | (if $value >= 0 then "+" else "" end) + ((($value * 10 | round) / 10) | tostring) + "%";
  (.[0] | measurements) as $before |
  (.[1] | measurements) as $after |
  [range(0; ($before | length)) | {
    benchmark: $before[.].command,
    before_ms: ($before[.].mean * 1000),
    after_ms: ($after[.].mean * 1000),
    delta_ms: (($after[.].mean - $before[.].mean) * 1000),
    percent: ((($after[.].mean / $before[.].mean) - 1) * 100)
  }] |
  ("benchmark\tbefore\tafter\tdelta\tchange"),
  (.[] | [.benchmark, (.before_ms | fmt_ms), (.after_ms | fmt_ms), (.delta_ms | fmt_delta_ms), (.percent | fmt_percent)] | @tsv)
' "$1" "$2"
