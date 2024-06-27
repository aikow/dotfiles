function projects
    fd -HI --type d '^\.git$' ~/workspace -x echo {//}
end
