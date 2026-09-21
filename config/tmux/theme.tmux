# Set the status bar position to the bottom
set-option -g status-position "bottom"

# Make the window list appear at the left-hand side instead of at the center.
set -g status-justify left
set -g status-left '#S  │  '
set -g status-interval 1

# Status line.
# Follow the terminal's foreground, background, and ANSI accent palette.
set -g status-style fg=terminal,bg=terminal,none
set -g status-right "#{?pane_synchronized,#[fg=yellow]SYNCHRONIZED#[default]  ,}#(whoami)@#H  %H:%M %a %d-%m-%Y"
set -g status-right-length 80

# Window list.
setw -g window-status-style fg=terminal,bg=terminal,none
setw -g window-status-format "#I #W"
setw -g window-status-separator "  "

# Active window.
setw -g window-status-current-style fg=blue,bg=terminal,bold
setw -g window-status-current-format "#I #W#F"

# Window activity.
setw -g window-status-activity-style fg=yellow,bg=terminal,underscore

# Panes.
set -g pane-border-style fg=terminal,bg=terminal
set -g pane-active-border-style fg=blue,bg=terminal

# Command/message line.
set -g message-style fg=terminal,bg=terminal,bold
