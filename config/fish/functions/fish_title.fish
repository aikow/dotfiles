function fish_title --description 'Project/workspace with a delayed running command in Ghostty'
    if set -q __fish_title_debounce
        # The background worker adds the command after 300 ms. Fish's own
        # immediate updates keep the idle title, including when returning to it.
        __fish_format_title
    else
        __fish_format_title $argv
    end
end
