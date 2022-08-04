function git_is_repo
  command -s -q git
  and git rev-parse HEAD >/dev/null 2>&1
end
