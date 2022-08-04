# Help parse the output from git branch -avv
function fzf_preview_branch --description "Print a preview for the given branch."
  # Truncate first two characters
  set branch (
    clean_string $argv |
    string sub --start 3 |
    string split --no-empty --fields 1 ' ' |
    string replace -r '^remotes/' ''
  )

  set log_format 'format:%C(auto)%cd %h%d %s %C(magenta)[%an]%Creset' 

  git log \
    --color=always \
    --oneline \
    --graph \
    --date=short \
    --pretty="$log_format" \
    $branch
end
