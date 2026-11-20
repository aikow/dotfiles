function __fish_ssh_title --description 'Read an SSH destination from a command without evaluating it'
    # fish_title receives shell source, not argv. Tokenize quotes safely; do
    # not expand variables or command substitutions just to compute a title.
    set -l tokens
    printf '%s\n' "$argv[1]" | read --tokenize --array tokens; or return 1
    if contains -- "$tokens[1]" command exec
        set -e tokens[1]
    end
    set -q tokens[1]; or return 1
    test (path basename -- "$tokens[1]") = ssh; or return 1
    set -e tokens[1]

    set -l skip_argument false
    set -l options_done false
    for token in $tokens
        if test "$skip_argument" = true
            set skip_argument false
            continue
        end
        if test "$options_done" = false
            if test "$token" = --
                set options_done true
                continue
            else if string match -q -- '-*' "$token"
                # OpenSSH short options can be bundled, and options with a
                # value accept either -p 2222 or -p2222. No ssh -G invocation:
                # that could run Match exec commands from the SSH config.
                set -l options (string sub -s 2 -- "$token" | string split '')
                for index in (seq (count $options))
                    switch "$options[$index]"
                        case G Q V O
                            return 1
                        case B b c D E e F I i J L l m o P p R S W w
                            if test "$index" -eq (count $options)
                                set skip_argument true
                            end
                            break
                        case 1 2 4 6 A a C f g K k M N n q s T t v X x Y y
                            # Options without an argument.
                        case '*'
                            return 1
                    end
                end
                continue
            end
        end

        # Show the SSH config alias, without user information or a URI port.
        set -l destination (string replace -r '^ssh://' '' -- "$token" | string replace -r '^.*@' '' | string replace -r '/.*$' '')
        if string match -qr '^\[[0-9a-fA-F:]+\](:[0-9]+)?$' -- "$destination"
            set destination (string replace -r '^\[([^]]+)\].*$' '$1' -- "$destination")
        else
            set destination (string replace -r '^([^:]+):[0-9]+$' '$1' -- "$destination")
        end
        string match -qr '^[[:alnum:]_.:-]{1,160}$' -- "$destination"; or return 1
        printf '%s\n' "$destination"
        return 0
    end
    return 1
end
