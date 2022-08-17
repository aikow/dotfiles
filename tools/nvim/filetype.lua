vim.filetype.add({
  extension = {
    wiki = "markdown",
    tmux = "tmux",
    nu = "nu",
    rsync = "rsync",
  },
  filename = {
    ["MANIFEST.in"] = "manifest",
    [".gitignore"] = "gitignore",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})
