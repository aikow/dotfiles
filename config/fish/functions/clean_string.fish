function clean_string
    if test $argv
        for line in $argv
            string replace -ra '\e\[[^m]*m' '' $line | string replace -ra '[^[:print:]]' ''
        end
    else
        while read line
            string replace -ra '\e\[[^m]*m' '' $line | string replace -ra '[^[:print:]]' ''
        end
    end
end
