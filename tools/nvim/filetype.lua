vim.filetype.add({
  extension = {
    nu = "nu",
    rsync = "rsync",
    tmux = "tmux",
    wiki = "markdown",
  },
  filename = {
    [".gitignore"] = "gitignore",
    ["aliases"] = "sh",
    ["bashrc"] = "bash",
    ["gitconfig"] = "gitconfig",
    ["MANIFEST.in"] = "manifest",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})
