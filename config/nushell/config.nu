# Nushell Config File

use ~/.config/nushell/themes

# The default config record. This is where much of your global configuration is setup.
$env.config = {
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: false # always act as if -t was given. Can be overridden with -p
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
  }
  explore: {
    help_banner: true
    exit_esc: false
  }
  history: {
    max_size: 65536 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "sqlite" # "sqlite" or "plaintext"
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "fuzzy"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
  }
  filesize: {
    metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  cursor_shape: {
    emacs: line
    vi_insert: line
    vi_normal: block
  }
  color_config: (themes default dark)
  footer_mode: 25 # always, never, number_of_rows, auto
  float_precision: 2
  # buffer_editor: "emacs" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  use_ansi_coloring: true
  edit_mode: vi # emacs, vi
  shell_integration: {
    # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
    osc2: true
    # osc7 is a way to communicate the path to the terminal, this is helpful
    # for spawning new tabs in the same directory
    osc7: true
    # osc8 is also implemented as the deprecated setting
    # ls.show_clickable_links, it shows clickable links in ls output if your
    # terminal supports it. show_clickable_links is deprecated in favor of
    # osc8
    osc8: true
    # osc9_9 is from ConEmu and is starting to get wider support. It's
    # similar to osc7 in that it communicates the path to the terminal
    osc9_9: false
    # osc133 is several escapes invented by Final Term which include the
    # supported ones below.
    # 133;A - Mark prompt start
    # 133;B - Mark prompt end
    # 133;C - Mark pre-execution
    # 133;D;exit - Mark execution finished with exit code
    # This is used to enable terminals to know where the prompt is, the
    # command is, where the command finishes, and where the output of the
    # command is
    osc133: true
    # osc633 is closely related to osc133 but only exists in visual studio
    # code (vscode) and supports their shell integration features
    # 633;A - Mark prompt start
    # 633;B - Mark prompt end
    # 633;C - Mark pre-execution
    # 633;D;exit - Mark execution finished with exit code
    # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
    # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
    # and also helps with the run recent menu in vscode
    osc633: true
    # reset_application_mode is escape \x1b[?1l and was added to help ssh
    # work better
    reset_application_mode: true
  }
  show_banner: false # true or false to enable or disable the banner
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.

  # ------------------------------------------------------------------------
  # | Hooks
  # ------------------------------------------------------------------------
  hooks: {
    pre_prompt: [{ || null }]
    pre_execution: [{ || null }]
    env_change: {
      PWD: [{ |before, after| ls; null }]
    }
    display_output: { || table }
  }

  # ------------------------------------------------------------------------
  # | Menus
  # ------------------------------------------------------------------------
  menus: [
    # Configuration for default nushell menus
    # Note the lack of souce parameter
    {
      name: ide_completion_menu
      only_buffer_difference: false
      marker: " 󰮫 "
      type: {
        layout: ide
        min_completion_width: 0,
        max_completion_width: 80,
        max_completion_height: 16,
        padding: 0,
        border: true,
        cursor_offset: 0,
        description_mode: "prefer_right"
        min_description_width: 0
        max_description_width: 50
        max_description_height: 10
        description_offset: 1
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "  "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: " 󰋖 "
      type: {
        layout: description
        columns: 4
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    # Example of extra menus created using a nushell source
    # Use the source field to create a list of records that populates
    # the menu
    {
      name: commands_menu
      only_buffer_difference: false
      marker: "  "
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        help commands
        | where name =~ $buffer
        | each { |it| {value: $it.name description: $it.usage} }
      }
    }
    {
      name: vars_menu
      only_buffer_difference: true
      marker: " 󰫧 "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        scope variables
        | where name =~ $buffer
        | sort-by name
        | each { |it| {value: $it.name description: $it.type} }
      }
    }
    {
      name: commands_with_description
      only_buffer_difference: true
      marker: "  "
      type: {
        layout: description
        columns: 4
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        scope commands
        | where name =~ $buffer
        | each { |it| {value: $it.name description: $it.usage} }
      }
    }
  ]

  # ------------------------------------------------------------------------
  # | Keybindings
  # ------------------------------------------------------------------------
  keybindings: [
    {
      name: fuzzy_history
      modifier: control
      keycode: char_r
      mode: [vi_insert vi_normal]
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (history | get command | uniq | reverse | str join (char -i 0) | fzf --scheme history --read0 --layout=reverse --height=40% --query (commandline) | decode utf-8 | str trim)"
      }
    }
    {
      name: history_hint_complete
      modifier: control
      keycode: char_f
      mode: [vi_insert vi_normal]
      event: { send: HistoryHintComplete }
    }
    {
      name: history_hint_word_complete
      modifier: control
      keycode: char_h
      mode: [vi_insert vi_normal]
      event: { send: HistoryHintWordComplete }
    }

    # ------------------
    # |   Bind Menus   |
    # ------------------
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [vi_insert]
      event: {
        until: [
          { send: menu name: ide_completion_menu }
          { send: menunext }
          { edit: complete }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [vi_normal vi_insert]
      event: { send: menuprevious }
    }

    # ---------------------
    # |   Helpful Menus   |
    # ---------------------
    {
      name: commands_menu
      modifier: alt
      keycode: char_c
      mode: [vi_normal vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: commands_with_description
      modifier: alt
      keycode: char_d
      mode: [vi_normal vi_insert]
      event: { send: menu name: commands_with_description }
    }
    {
      name: vars_menu
      modifier: alt
      keycode: char_v
      mode: [vi_normal vi_insert]
      event: { send: menu name: vars_menu }
    }
  ]
}

# ------------------------------------------------------------------------
# | Load Extra Modules
# ------------------------------------------------------------------------
use ~/.config/nushell/completions *
source ~/.config/nushell/lib/aliases.nu
