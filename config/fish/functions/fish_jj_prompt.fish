function fish_jj_prompt
  # If jj isn't installed, there's nothing we can do
  # Return 1 so the calling prompt can deal with it
  if ! command -sq jj
    return 1
  end
  # Check if we're in a jj repo
  if ! jj root --ignore-working-copy --quiet &>/dev/null
    return 1
  end

  if test -n "$__fish_jj_prompt_bookmark_revset"
    set prompt_bookmark_revset "$__fish_jj_prompt_bookmark_revset"
  else
    set prompt_bookmark_revset "@ | @-"
  end

  set current_head (jj log --color=always --no-graph --ignore-working-copy \
    -r "@" -T "change_id.shortest()")
  set current_branch (jj log --color=always --no-graph --ignore-working-copy \
    -r "latest(($prompt_bookmark_revset) & bookmarks())" \
    -T "bookmarks.join(' ')")
  if test -n "$current_branch"
    echo " ($current_head|$current_branch)"
  else
    echo " ($current_head)"
  end
end
