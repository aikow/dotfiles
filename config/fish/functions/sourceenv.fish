function sourceenv -d "source environment variables defined in a file"
    argparse --min-args 1 --max-args 1 n/dryrun v/verbose -- $argv
    or exit 1

    set file $argv[1]

    # Ignore all empty lines and commented lines
    for line in (string match -rv '^\s*(#|$)' <$file)
        set parts (string split -m 1 '=' $line)

        # Remove an optional 'export' prefix from the key
        set key (string replace -r '^\s*export\s+' '' $parts[1])
        set val $parts[2]

        # Remove surrounding quotes if present, and expand any environment
        # variables when not surrounded with single quotes
        if test (string sub -e1 $val) = \"
            set val (string trim -c\" $val | envsubst)
        else if test (string sub -e1 $val) = \'
            set val (string trim -c\' $val)
        else
            set val (echo $val | envsubst)
        end

        # Don't update the environment if --dryrun is enabled
        if not set -q _flag_dryrun
            set -gx $key $val
        end

        # Only print out messages if --verbose is enabled
        if test (count $_flag_verbose) -eq 1
            echo "export $key=..."
        else if test (count $_flag_verbose) -gt 1
            echo "export $key=$val"
        end
    end
end
