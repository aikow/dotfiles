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

    $"($user_segment)@($hostname_segment) ($path_segment)"
}

def create_right_prompt [] { ||
    let time_segment = ([
        (date now | format date '%T %d-%m-%Y')
    ] | str join)

    $time_segment
}

# Customize the prompt commands
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { || create_right_prompt }

# Customize the prompt imdicators
$env.PROMPT_INDICATOR = { || "〉" }
$env.PROMPT_INDICATOR_VI_INSERT = { || "〉" }
$env.PROMPT_INDICATOR_VI_NORMAL = { || ": " }
$env.PROMPT_MULTILINE_INDICATOR = { || "::: " }
