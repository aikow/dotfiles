function __fish_format_title --description 'Project/workspace or SSH host, plus the running command'
    # Names come from local paths and repository metadata. Never evaluate them
    # as commands or emit a remote URL (which may contain credentials).
    set -l title
    if set -q argv[1]
        set title (__fish_ssh_title "$argv[1]")
    end
    if set -q title[1]
        # A local SSH command: prefer the alias the user connected to. This
        # also works through Ghostty's SSH integration wrapper.
    else if set -q SSH_TTY; or set -q SSH_CONNECTION
        set title (prompt_hostname)
    else
        set -l root "$PWD"
        while test "$root" != /
            if test -e "$root/.jj"; or test -e "$root/.git"
                break
            end
            set root (path dirname -- "$root")
        end

        set -l remote
        if test -d "$root/.jj"; and command -sq jj
            # Read only: title updates must never snapshot a JJ working copy.
            set -l remotes (command jj --repository "$root" --ignore-working-copy --color never git remote list 2>/dev/null)
            set -l selected (string match -r '^origin[ \t]+.*$' -- $remotes)
            if not set -q selected[1]
                set selected $remotes[1]
            end
            if set -q selected[1]
                set remote (string replace -r '^[^ \t]+[ \t]+' '' -- "$selected[1]")
            end
        else if test -e "$root/.git"; and command -sq git
            set remote (command git --no-optional-locks -C "$root" config --get remote.origin.url 2>/dev/null)
            if not set -q remote[1]
                set -l remotes (command git --no-optional-locks -C "$root" remote 2>/dev/null)
                if set -q remotes[1]
                    set remote (command git --no-optional-locks -C "$root" config --get "remote.$remotes[1].url" 2>/dev/null)
                end
            end
        end

        if test "$root" != /
            set title (path basename -- "$root")
            if set -q remote[1]
                # Accept HTTPS, SSH/scp and local-path remotes. Only the final
                # path component is a candidate for display.
                set -l project (string replace -r '[?#].*$' '' -- "$remote[1]" | string trim -r -c / | string replace -r '^.*[/:]' '' | string replace -r '\.git$' '')
                if string match -qr '^[[:alnum:]_. -]{1,80}$' -- "$project"
                    set -l parent (path basename -- (path dirname -- "$root"))
                    if test (string lower -- "$parent") = (string lower -- "$project"); and not contains -- "$title" main master
                        set title "$project ($title)"
                    else
                        set title "$project"
                    end
                end
            end
        else
            set title (__fish_path_title "$PWD")
        end
    end

    # The foreground command is shell source. Tokenize without evaluation and
    # show only the executable name, keeping arguments (and secrets) private.
    if set -q argv[1]; and test -n "$argv[1]"
        set -l tokens
        printf '%s\n' "$argv[1]" | read --tokenize --array tokens
        while set -q tokens[1]; and contains -- "$tokens[1]" command exec builtin
            set -e tokens[1]
        end
        if set -q tokens[1]
            set -l executable (path basename -- "$tokens[1]")
            if string match -qr '^[[:alnum:]_.+-]{1,255}$' -- "$executable"
                if test (string length -- "$executable") -gt 24
                    set executable (string sub -l 23 -- "$executable")…
                end
                set title "$title · $executable"
            end
        end
    end

    # Titles are terminal-protocol input: reject control characters and bound
    # the output. No raw command arguments, URLs or escape sequences reach it.
    if string match -qr '^[[:alnum:]_.: /~@()+·…-]{1,320}$' -- "$title"
        printf '%s\n' "$title"
    else
        printf '%s\n' fish
    end
end
