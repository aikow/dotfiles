status is-interactive; or return
test "$TERM_PROGRAM" = ghostty; or return

set -g __fish_title_debounce 1

function __fish_cancel_title --on-event fish_postexec --on-event fish_prompt --on-event fish_exit
    if set -q __fish_title_worker
        # A disowned worker may already have exited. Only signal a process
        # still belonging to this shell, never an unrelated recycled PID.
        set -l parent (command ps -o ppid= -p "$__fish_title_worker" 2>/dev/null | string trim)
        if test "$parent" = "$fish_pid"
            command kill -TERM "$__fish_title_worker" 2>/dev/null
        end
        set -e __fish_title_worker
    end
end

function __fish_delay_title --on-event fish_preexec
    __fish_cancel_title
    # Raw shell source stays in Fish's non-evaluating formatter. The worker
    # receives only its bounded, allowlisted output as a positional argument.
    set -l title (__fish_format_title "$argv[1]")
    command sh -c 'sleep 0.3; printf "\033]0;%s\007" "$1"' title "$title" </dev/null >/dev/tty 2>/dev/null &
    set -g __fish_title_worker $last_pid
    disown "$__fish_title_worker" 2>/dev/null
end
