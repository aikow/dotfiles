vim.filetype.add({
  extension = {
    wiki = "markdown",
    tmux = "tmux",
  },
  filename = {
    ["MANIFEST.in"] = "manifest",
    [".gitignore"] = "gitignore",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})
