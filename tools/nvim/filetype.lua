vim.filetype.add({
  extension = {
    wiki = "markdown",
    tmux = "tmux",
    nu = "nu",
  },
  filename = {
    ["MANIFEST.in"] = "manifest",
    [".gitignore"] = "gitignore",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})
