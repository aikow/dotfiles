function lsgit
    fd --type d -HI '^\.git$' -x echo {//} | sort
end
