function lsgit
    fd -HI --type d '^\.git$' $argv[1] -x echo {//}
end
