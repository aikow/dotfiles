function git_toplevel
  commandline -r "cd (git rev-parse --show-toplevel)"
  commandline -f execute
end
