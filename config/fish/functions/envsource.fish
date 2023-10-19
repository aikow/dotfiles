function envsource -d "Add a .env file to your current environment"
    if test (count $argv) -ne 1
        echo "Expected exactly 1 argument"
        return 1
    end

    set -l lines (cat $argv[1] | grep -v '^\s*#' | grep -v '^\s*$')
    for line in $lines
        set item (string split -m 1 '=' $line)

        set key $item[1]

        set val (string trim $item[2])
        if test (string sub -e1 $val) = \"
            set val (string trim -c\" $val)
        else if test (string sub -e1 $val) = \'
            set val (string trim -c\' $val)
        end

        set -gx $key $val
        echo "Exported key $key"
    end
end
