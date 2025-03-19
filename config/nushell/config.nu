use ~/.config/nushell/themes

# History
$env.config.history.file_format = "sqlite"

# Completions
$env.config.completions.algorithm = "fuzzy"
$env.config.edit_mode = "vi"

# Appearance
$env.config.show_banner = false
$env.config.color_config = (themes default dark)
$env.config.cursor_shape = {
  emacs: line
  vi_insert: line
  vi_normal: block
}

# Never print the expanded table automatically
$env.config.hooks.display_output = { || table }

# ------------------------------------------------------------------------
# | Menus
# ------------------------------------------------------------------------
$env.config.menus ++= [
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
$env.config.keybindings ++= [
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

  # Bind Menus
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

  # Helpful Menus
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

# Aliases
alias ll = ls -l

# List everything with detailed information.
alias lll = ls -la

# Load custom completions
use ~/.config/nushell/completions/git.nu
