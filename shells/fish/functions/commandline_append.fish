# Deciphered from fzf-file-widget. Somewhat unclear why it doesn't exist already!
function commandline_append -d 'add stdin to the command line, for fzf functions'
  read -l result
  commandline -t ""
  commandline -it -- (string escape $result)
  commandline -f repaint
end

