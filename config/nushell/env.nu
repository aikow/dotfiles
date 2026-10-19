# File colors: use the terminal's ANSI palette so colors follow its theme.
$env.LS_COLORS = (open --raw ($env.HOME | path join ".dotfiles" "config" "dircolors" "ls_colors") | str trim)

# Fzf options shared with Bash, Zsh, and Fish.
$env.FZF_DEFAULT_OPTS = (open --raw ($env.HOME | path join ".dotfiles" "config" "fzf" "default_opts") | str trim)

def create_left_prompt [] { ||
    let path_segment = (
      $env.PWD
      | str replace $env.HOME '~'
      | path split
      | last 3
      | path join
    )

    let user_segment = (
      $env.USER
    )

    let hostname_segment = (
      hostname | str trim
    )

    $"($user_segment)@($hostname_segment) ($path_segment)\n"
}

# Customize the prompt commands
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {||}

# Customize the prompt imdicators
$env.PROMPT_INDICATOR = { || "〉" }
$env.PROMPT_INDICATOR_VI_INSERT = { || "〉" }
$env.PROMPT_INDICATOR_VI_NORMAL = { || ": " }
$env.PROMPT_MULTILINE_INDICATOR = { || "::: " }
