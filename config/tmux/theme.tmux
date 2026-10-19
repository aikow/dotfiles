# Set the status bar position to the bottom
set-option -g status-position "bottom"

# Make the window list appear at the left-hand side instead of at the center.
set -g status-justify left
set -g status-left '#S │ '
set -g status-left-length 20
set -g status-interval 1

# Status line.
# Ghostty follows OS appearance and reports changes to tmux (3.6+).
# Evaluate per client on redraw so light/dark clients can share a session.
# Neutral greys suit most palettes; keep the terminal's foreground and accents.
set -s theme detect
set -g @status-background '#{?#{==:#{client_theme},light},#e6e6e6,#333333}'
set -g status-style 'fg=terminal,bg=#{E:@status-background},none'
set -g status-right "#{?pane_synchronized,#[fg=yellow]SYNCHRONIZED#[default]  ,}#(whoami)@#H  %H:%M %a %d-%m-%Y"
set -g status-right-length 80

# Window list.
setw -g window-status-style 'fg=terminal,bg=#{E:@status-background},none'
setw -g window-status-format "#I #W"
setw -g window-status-separator "  "

# Active window.
setw -g window-status-current-style 'fg=blue,bg=#{E:@status-background},bold'
setw -g window-status-current-format "#I #W#F"

# Window activity.
setw -g window-status-activity-style fg=yellow,bg=terminal,underscore

# Panes.
set -g pane-border-style fg=terminal,bg=terminal
set -g pane-active-border-style fg=blue,bg=terminal

# Command/message line.
# Use explicit text colors for contrast when the terminal changes appearance.
set -g @message-foreground '#{?#{==:#{client_theme},light},#333333,#e6e6e6}'
# Clear the whole row so status content does not show beside the prompt.
set -g message-style 'fg=#{E:@message-foreground},bg=#{E:@status-background},fill=#{E:@status-background},bold'
set -g message-command-style 'fg=#{E:@message-foreground},bg=#{E:@status-background},fill=#{E:@status-background},bold'
