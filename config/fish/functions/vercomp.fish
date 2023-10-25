# Compare version strings

function vercomp --description "Compares two version strings and returns and integer."
    # Check that we have 3 arguments exactly.
    if test ! (count $argv) -eq 3
        echo "vercomp requires 3 arguments"
        return 1
    end

    # Check that the operator is a valid operator for this command.
    if ! string match -r -e -- '-(?<operator>lt|eq|gt)' $argv[2] &>/dev/null
        echo "vercomp requires 2 argument to be either '-lt', '-gt' or '-eq'"
        return 1
    end

    # Check if the two version strings are equal.
    if test $argv[1] = $argv[3]
        if test $operator = eq
            return 0
        else
            return 1
        end
    end

    # Split both version strings on the period.
    set -l ver1 (string split '.' $argv[1])
    set -l ver2 (string split '.' $argv[3])

    # Fill empty fields in ver1 with zeros.
    for i in (seq (count $ver1) (count $ver2))
        set -a ver1 0
    end

    # Iterate over the zipped fields of both ver1 and ver2.
    for i in (seq 1 (count $ver1))
        # fill empty fields in ver2 with zeros
        if test -z $ver2[$i]
            set -a ver2 0
        end

        # If version 1 is greater than version 2 and the operator is also greater
        # than, return success, otherwise false.
        if test $ver1[$i] -gt $ver2[$i]
            if test $operator = gt
                return 0
            else
                return 1
            end
        end

        # If version 1 is less than version 2 and the operator is also less than,
        # return success, otherwise false.
        if test $ver1[$i] -lt $ver2[$i]
            if test $operator = lt
                return 0
            else
                return 1
            end
        end
    end

    # If we got here, it means both version strings are equal, for example 4.0
    # and 4 are both equal, but would have failed the first test. Return success
    # only if the operator is equal though, otherwise return an error code.
    if test $operator = eq
        return 0
    else
        return 1
    end
end
