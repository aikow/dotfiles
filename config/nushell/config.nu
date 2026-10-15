# History
$env.config.history.file_format = "sqlite"

# Completions
$env.config.completions.algorithm = "fuzzy"
$env.config.edit_mode = "vi"

# Appearance
$env.config.show_banner = false
$env.config.cursor_shape = {
  emacs: line
  vi_insert: line
  vi_normal: block
}

# Never print the expanded table automatically
$env.config.hooks.display_output = { || table }

# Aliases
alias ll = ls -l
alias lll = ls -la
