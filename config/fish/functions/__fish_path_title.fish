function __fish_path_title --description 'Full path, abbreviated only beyond 50 characters'
    # Paths are display data, never shell source. Reject unsafe characters
    # before shortening so an abbreviated component cannot hide terminal codes.
    set -l directory "$argv[1]"
    if not string match -qr '^[[:alnum:]_.: /~@()+…-]{1,4096}$' -- "$directory"
        printf '%s\n' fish
        return
    end
    set directory (string replace -r '^'(string escape --style=regex -- "$HOME")'(?=/|$)' '~' -- "$directory")
    if test (string length -- "$directory") -le 50
        printf '%s\n' "$directory"
        return
    end

    set -l parts (string split / -- "$directory")
    set -l shortened $parts
    set -l last (count $parts)
    if test $last -le 2
        printf '%s\n' "$directory"
        return
    end
    # Preserve the root marker and final folder. Abbreviate from the left,
    # keeping as many of the later folders fully readable as will fit.
    for index in (seq 2 (math $last - 1))
        set -l length 1
        string match -q '.*' -- "$parts[$index]"; and set length 2
        set shortened[$index] (string sub -l $length -- "$parts[$index]")
        set -l title (string join / -- $shortened)
        if test (string length -- "$title") -le 50
            printf '%s\n' "$title"
            return
        end
    end

    # If initials still do not fit, collapse the middle. Prefer the original
    # first folder and restore as much of the original suffix as will fit.
    set -l prefix (string join / -- $parts[1..2])
    set -l suffix "$parts[-1]"
    set -l title "$prefix/…/$suffix"
    if test (string length -- "$title") -gt 50; or test $last -le 3
        set prefix "$parts[1]"
        set title "$prefix/…/$suffix"
    end
    if test $last -gt 3
        for index in (seq (math $last - 1) -1 3)
            set -l candidate "$prefix/…/$parts[$index]/$suffix"
            if test (string length -- "$candidate") -gt 50
                break
            end
            set suffix "$parts[$index]/$suffix"
            set title "$candidate"
        end
    end
    # 50 is a target: a final folder longer than that stays intact.
    printf '%s\n' "$title"
end
